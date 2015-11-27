//
//  Figo.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import Alamofire


public typealias ProgressUpdate = (message: String) -> Void
public typealias PinResponder = (message: String, accountID: String) -> String
public typealias ChallengeResponder = (message: String, accountID: String, challenge: Challenge) -> String
public typealias CompletionHandler = (error: Error?) -> Void


class Session {
    static let sharedInstance = Session()
    private init() {} // This prevents others from using the default '()' initializer for this class.

    private var _accessToken: String?
    var accessToken: String? {
        get {
            return _accessToken
        }
        set {
            _accessToken = newValue
        }
    }
    var refreshToken: String?
    var secret: String?
    
    /// Milliseconds between polling task states
    static let pollingInterval: Int64 = Int64(400) * Int64(NSEC_PER_MSEC)
}




/**
 CREDENTIAL LOGIN
 
 Requests authorization with credentials. Authorization can be obtained as long
 as the user has not revoked the access granted to your application.
 
 The returned refresh token can be stored by the client for future logins, but only
 in a securely encryped store like the keychain or a SQLCipher database.
 
 - parameter username: The figo account email address
 - parameter password: The figo account password
 - parameter clientdID: The figo client identifier
 - parameter clientdSecret: The figo client sclient
 - parameter completionHandler: Returns refresh token or error
 */
public func loginWithUsername(username: String, password: String, clientID: String, clientSecret: String, completionHandler: (refreshToken: String?, error: Error?) -> Void) {
    let secret = base64Encode(clientID, clientSecret)
    let request = Endpoint.LoginUser(username: username, password: password, secret: secret)
    fireRequest(request).responseObject() { (authorization: Authorization?, error: Error?) -> Void in
        Session.sharedInstance.accessToken = authorization?.access_token
        Session.sharedInstance.refreshToken = authorization?.refresh_token
        Session.sharedInstance.secret = secret
        completionHandler(refreshToken: authorization?.refresh_token, error: error)
    }
}

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
        completionHandler(error: error)
    }
}

/**
 REVOKE TOKEN
 
 Invalidates the session's access token for simulating an expired access token.
 
 After revoking the access token, with the next API call a new one is fetched automatically if the refresh token is still valid.
 
 - parameter completionHandler: Returns nothing or error
 */
public func revokeAccessToken(completionHandler: (error: Error?) -> Void) {
    fireRequest(Endpoint.RevokeToken(token: Session.sharedInstance.accessToken ?? ""))
        .response { request, response, data, error in
            debugPrintRequest(request, response, data)
            if let error = error {
                completionHandler(error: Error.NetworkLayerError(error: error))
            } else {
                completionHandler(error: nil)
            }
    }
}

/**
 REVOKE TOKEN
 
 Invalidates access token and refresh token, after that CREDENTIAL LOGIN is required.
 
 You might call this **LOGOUT**.
 
 - parameter refreshToken: The client's refresh token, defaults to the session's refresh token
 - parameter completionHandler: Returns nothing or error
 */
public func revokeRefreshToken(refreshToken: String?, completionHandler: (error: Error?) -> Void) {
    let token: String = {
        if refreshToken != nil { return refreshToken! }
        else { return Session.sharedInstance.refreshToken ?? "" }
    }()
    fireRequest(Endpoint.RevokeToken(token: token))
        .response { request, response, data, error in
            debugPrintRequest(request, response, data)
            if let error = error {
                completionHandler(error: Error.NetworkLayerError(error: error))
            } else {
                Session.sharedInstance.accessToken = nil
                completionHandler(error: nil)
            }
    }
}

public func retrieveAccount(accountID: String, completionHandler: (account: Account?, error: Error?) -> Void) {
    let request = Endpoint.RetrieveAccount(accountId: accountID)
    fireRequest(request).responseObject() { account, error in
        retryRequestingObjectOnInvalidTokenError(request, account, error, completionHandler)
    }
}

public func retrieveAccounts(completionHandler: (accounts: [Account]?, error: Error?) -> Void) {
    let request = Endpoint.RetrieveAccounts
    fireRequest(request).responseCollection() { accounts, error in
        retryRequestingCollectionOnInvalidTokenError(request, accounts, error, completionHandler)
    }
}

public func retrieveCurrentUser(completionHandler: (user: User?, error: Error?) -> Void) {
    let request = Endpoint.RetrieveCurrentUser
    fireRequest(request).responseObject() { user, error in
        retryRequestingObjectOnInvalidTokenError(request, user, error, completionHandler)
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
    let request = Endpoint.SetupNewAccount(account)
    fireRequest(request).responseJSON() { response in
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

func fireRequest(request: URLRequestConvertible) -> Request {
    return Alamofire.request(request).validate()
}








