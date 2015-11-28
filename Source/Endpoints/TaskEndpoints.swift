//
//  TaskEndpoints.swift
//  Figo
//
//  Created by Christian König on 28.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation

public typealias ProgressUpdate = (message: String) -> Void
public typealias PinResponder = (message: String, accountID: String) -> String
public typealias ChallengeResponder = (message: String, accountID: String, challenge: Challenge) -> String

public typealias CompletionHandler = (error: FigoError?) -> Void
public typealias VoidCompletionHandler = (result: FigoResult<Void>) -> Void


extension FigoSession {
    
    private func delay(block: () -> Void) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, POLLING_INTERVAL_MSECS), dispatch_get_main_queue(), {
            block()
        })
    }
    
    
    /**
     BEGIN TASK

     Start communication with bank server.
     */
    func beginTask(token: String, _ completionHandler: CompletionHandler) {
        request(Endpoint.BeginTask(taskToken: token)) { data, error in
            guard error == nil else {
                completionHandler(error: error)
                return
            }
            self.pollTaskState(token, self.POLLING_COUNTDOWN_INITIAL_VALUE, completionHandler)
        }
    }
    
    /**
     POLL TASK STATE
     
     While the figo Connect server communicates with a bank server, your application can monitor its progress by periodically polling this method
     */
    func pollTaskState(token: String, _ countdown: Int, _ completionHandler: CompletionHandler) {
        guard countdown > 0 else {
            completionHandler(error: FigoError.TaskProcessingTimeout)
            return
        }
        let parameters = PollTaskStateParameters(id: token, pin: nil, continueAfterError: nil, savePin: nil, response: nil)
        request(Endpoint.PollTaskState(parameters)) { data, error in
            guard error == nil else {
                completionHandler(error: error!)
                return
            }
            let decoded: (TaskState?, FigoError?) = decodeObject(data)
            if let decodingError = decoded.1 {
                completionHandler(error: decodingError)
                return
            }
            else if let state = decoded.0 {
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
                    self.delay() {
                        self.pollTaskState(token, countdown - 1, completionHandler)
                    }
                    return
                }
            } else {
                completionHandler(error: FigoError.UnspecifiedError(reason: "Failed to poll task state"))
                return
            }
        }
        
    }
    
}
