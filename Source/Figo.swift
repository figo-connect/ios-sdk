//
//  Figo.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public typealias ProgressUpdate = (message: String) -> Void
public typealias PinResponder = (message: String, accountID: String) -> String
public typealias ChallengeResponder = (message: String, accountID: String, challenge: Challenge) -> String
public typealias CompletionHandler = (error: FigoError?) -> Void




func delay(block: () -> Void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Session.pollingInterval), dispatch_get_main_queue(), {
        block()
    })
}

/**
 SETUP NEW BANK ACCOUNT
 
 The figo Connect server will transparently create or modify a bank contact to add additional bank accounts.
 */
public func setupNewBankAccount(account: NewAccount, completionHandler: CompletionHandler) {
    guard Session.sharedInstance.accessToken != nil else {
        completionHandler(error: FigoError.NoActiveSession)
        return
    }
    fireRequest(Endpoint.SetupNewAccount(account)).responseJSON() { response in
        debugPrintRequest(response.request, response.response, response.data)
        switch response.result {
        case .Success(let value):
            if let JSON = value as? [String: String] {
                if let token = JSON["task_token"] {
                    processTask(token, completionHandler: completionHandler)
                } else {
                    completionHandler(error: FigoError.JSONMissingMandatoryValue(key: "task_token", typeName: "SetupNewBankAccount"))
                }
            } else {
                completionHandler(error: FigoError.JSONMissingMandatoryKey(key: "task_token", typeName: "SetupNewBankAccount"))
            }
            break
        case .Failure(let error):
            completionHandler(error: wrapError(error, data: response.data))
            break
        }
        
    }
    
}

func processTask(token: String, completionHandler: CompletionHandler) {
    let parameters = PollTaskStateParameters(id: token, pin: nil, continueAfterError: nil, savePin: nil, response: nil)
    fireRequest(Endpoint.PollTaskState(parameters)).responseObject() { (state: TaskState?, error: FigoError?) -> Void in
        if let error = error {
            completionHandler(error: error)
            return
        }
        if let state = state {
            if state.is_ended {
                if state.is_erroneous {
                    completionHandler(error: FigoError.TaskProcessingError(accountID: state.account_id, message: state.message))
                    return
                } else {
                    completionHandler(error: nil)
                    return
                }
            } else {
                print(state.message)
                delay() {
                    processTask(token, completionHandler: completionHandler)
                }
                return
            }
        } else {
            completionHandler(error: FigoError.UnspecifiedError(reason: "Failed to poll get task state"))
            return
        }
    }
    
}








