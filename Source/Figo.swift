//
//  Figo.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import Alamofire


/**
 Checks whether there is an access token that can be used to talk to the API.
*/
public var isUserLoggedIn: Bool {
    get {
        return Session.sharedSession.authorization?.access_token != nil
    }
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
        Session.sharedSession.authorization = authorization
        Session.sharedSession.secret = secret
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
        Session.sharedSession.authorization = authorization
        Session.sharedSession.secret = secret
        completionHandler(error: error)
    }
}

/**
 EXCHANGE REFRESH TOKEN
 
 Replaces expired access token for the current session.
 
 - parameter completionHandler: Returns nothing or error
*/
func refreshAccessToken(completionHandler: (error: Error?) -> Void) {
    guard   let secret = Session.sharedSession.secret,
            let authorization = Session.sharedSession.authorization else {
        completionHandler(error: Error.NoActiveSession)
        return
    }
    let request = Endpoint.RefreshToken(token: authorization.refresh_token!, secret: secret)
    fireRequest(request).responseObject() { (authorization: Authorization?, error: Error?) -> Void in
        Session.sharedSession.authorization = authorization
        Session.sharedSession.secret = secret
        completionHandler(error: error)
    }
}

/**
 REVOKE TOKEN
 
 Invalidates the session's access token for testing automatic refreshing of expired access tokens.

 - parameter completionHandler: Returns nothing or error
*/
func revokeAccessToken(completionHandler: (error: Error?) -> Void) {
    fireRequest(Endpoint.RevokeToken(token: Session.sharedSession.authorization?.access_token ?? ""))
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
 
 TODO: Think about renaming this to logout

 - parameter refreshToken: The client's refresh token, defaults to the session's refresh token
 - parameter completionHandler: Returns nothing or error
 */
public func revokeRefreshToken(refreshToken: String?, completionHandler: (error: Error?) -> Void) {
    let token: String = {
        if refreshToken != nil { return refreshToken! }
        else { return Session.sharedSession.authorization?.refresh_token ?? "" }
    }()
    fireRequest(Endpoint.RevokeToken(token: token))
        .response { request, response, data, error in
            debugPrintRequest(request, response, data)
            if let error = error {
                completionHandler(error: Error.NetworkLayerError(error: error))
            } else {
                Session.sharedSession.authorization = nil
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

