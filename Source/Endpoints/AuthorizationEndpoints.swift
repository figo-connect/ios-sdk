//
//  Authorization.swift
//  Figo
//
//  Created by Christian König on 27.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


extension FigoSession {
    
    /**
     CREDENTIAL LOGIN
     
     Requests authorization with credentials. Authorization can be obtained as long
     as the user has not revoked the access granted to your application.
     
     The returned refresh token can be stored by the client for future logins, but only
     in a securely encryped store like the keychain or a SQLCipher database.
     
     - parameter username: The figo account email address
     - parameter password: The figo account password
     - parameter completionHandler: Returns refresh token or error
     */
    public func loginWithUsername(username: String, password: String, completionHandler: (refreshToken: String?, error: Error?) -> Void) {
        request(.LoginUser(username: username, password: password)) { (data, error) -> Void in
            let decoded: (Authorization?, Error?) = decodeObject(data)
            self.accessToken = decoded.0?.access_token
            self.refreshToken = decoded.0?.refresh_token
            completionHandler(refreshToken: decoded.0?.refresh_token, error: decoded.1 ?? error)
        }
    }
    
    /**
     REVOKE TOKEN
     
     Invalidates the session's access token for simulating an expired access token.
     
     After revoking the access token, with the next API call a new one is fetched automatically if the refresh token is still valid.
     
     - parameter completionHandler: Returns nothing or error
     */
    public func revokeAccessToken(completionHandler: (error: Error?) -> Void) {
        request(.RefreshToken(token: self.accessToken!)) { (data, error) -> Void in
            completionHandler(error: error)
        }
    }
    
    /**
     REVOKE TOKEN
     
     Invalidates access token and refresh token, after that CREDENTIAL LOGIN is required.
     
     You might call this **LOGOUT**.
     
     - Parameter refreshToken: The client's refresh token, defaults to the session's refresh token
     - Parameter completionHandler: Returns nothing or error
     */
    public func revokeRefreshToken(refreshToken: String, completionHandler: (error: Error?) -> Void) {
        request(.RevokeToken(token: refreshToken)) { (data, error) -> Void in
            completionHandler(error: error)
        }
    }
    
}

