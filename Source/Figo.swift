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
public typealias CompletionHandler = (error: Error?) -> Void







/**
 EXCHANGE REFRESH TOKEN
 
 Requests new access token with refresh token. New access tokens can be obtained as long
 as the user has not revoked the access granted to your application.
 
 - Parameter refreshToken: The refresh token returned from a previous CREDENTIAL LOGIN
 - parameter completionHandler: Returns nothing or error
 */
public func loginWithRefreshToken(refreshToken: String, clientID: String, clientSecret: String, completionHandler: (error: Error?) -> Void) {
    let secret = base64Encode(clientID, clientSecret)
    let request = Endpoint.RefreshToken(token: refreshToken, secret: secret)
    fireRequest(request).responseObject() { (authorization: Authorization?, error: Error?) -> Void in
        Session.sharedInstance.accessToken = authorization?.access_token
        Session.sharedInstance.refreshToken = authorization?.refresh_token
        Session.sharedInstance.secret = secret
        completionHandler(error: error)
    }
}

/**
 EXCHANGE REFRESH TOKEN
 
 Replaces expired access token for the current session.
 
 - parameter completionHandler: Returns nothing or error
 */
func refreshAccessToken(completionHandler: (error: Error?) -> Void) {
    guard let secret = Session.sharedInstance.secret, let refreshToken = Session.sharedInstance.refreshToken else {
        completionHandler(error: Error.NoActiveSession)
        return
    }
    let request = Endpoint.RefreshToken(token: refreshToken, secret: secret)
    fireRequest(request).responseObject() { (authorization: Authorization?, error: Error?) -> Void in
        Session.sharedInstance.accessToken = authorization?.access_token
        Session.sharedInstance.refreshToken = authorization?.refresh_token
        completionHandler(error: error)
    }
}





public func retrieveAccount(accountID: String, completionHandler: (account: Account?, error: Error?) -> Void) {
    guard Session.sharedInstance.accessToken != nil else {
        completionHandler(account: nil, error: Error.NoActiveSession)
        return
    }
    fireRequest(Endpoint.RetrieveAccount(accountId: accountID))
        .responseObject() { account, error in
            completionHandler(account: account, error: error)
        }
}

public func retrieveAccounts(completionHandler: (accounts: [Account]?, error: Error?) -> Void) {
    guard Session.sharedInstance.accessToken != nil else {
        completionHandler(accounts: nil, error: Error.NoActiveSession)
        return
    }
    fireRequest(Endpoint.RetrieveAccounts).responseCollection() { accounts, error in
        completionHandler(accounts: accounts, error: error)
    }
}

public func retrieveCurrentUser(completionHandler: (user: User?, error: Error?) -> Void) {
    guard Session.sharedInstance.accessToken != nil else {
        completionHandler(user: nil, error: Error.NoActiveSession)
        return
    }
    fireRequest(Endpoint.RetrieveCurrentUser).responseObject() { user, error in
        completionHandler(user: user, error: error)
    }
}

public func createNewFigoUser(user: NewUser, clientID: String, clientSecret: String, completionHandler: (recoveryPassword: String?, error: Error?) -> Void) {
    let secret = base64Encode(clientID, clientSecret)
    let request = Endpoint.CreateNewFigoUser(user: user, secret: secret)
    fireRequest(request).responseJSON() { response in
        debugPrintRequest(response.request, response.response, response.data)
        switch response.result {
        case .Success(let value):
            if let JSON = value as? [String: String] {
                completionHandler(recoveryPassword: JSON["recovery_password"], error: nil)
            } else {
                completionHandler(recoveryPassword: nil, error: Error.JSONMissingMandatoryKey(key: "recovery_password", typeName: "CreateNewFigoUserResponse"))
            }
            break
        case .Failure(let error):
            completionHandler(recoveryPassword: nil, error: wrapError(error, data: response.data))
            break
        }
    }
}

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
        completionHandler(error: Error.NoActiveSession)
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
                    completionHandler(error: Error.JSONMissingMandatoryValue(key: "task_token", typeName: "SetupNewBankAccount"))
                }
            } else {
                completionHandler(error: Error.JSONMissingMandatoryKey(key: "task_token", typeName: "SetupNewBankAccount"))
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
    fireRequest(Endpoint.PollTaskState(parameters)).responseObject() { (state: TaskState?, error: Error?) -> Void in
        if let error = error {
            completionHandler(error: error)
            return
        }
        if let state = state {
            if state.is_ended {
                if state.is_erroneous {
                    completionHandler(error: Error.TaskProcessingError(accountID: state.account_id, message: state.message))
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
            completionHandler(error: Error.UnspecifiedError(reason: "Failed to poll get task state"))
            return
        }
    }
    
}


public func removeStoredPinFromBankContact(bankId: String, completionHandler: CompletionHandler) {
    let request = Endpoint.RemoveStoredPin(bankId: bankId)
    fireRequest(request).responseWithoutContent(completionHandler)
}

func fireRequest(request: URLRequestConvertible) -> Request {
    return Alamofire.request(request).validate()
}








