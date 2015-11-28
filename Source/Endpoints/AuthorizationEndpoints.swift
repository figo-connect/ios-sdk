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
     
     - Parameter username: The figo account email address
     - Parameter password: The figo account password
     - Parameter completionHandler: Returns refresh token or error
     */
    public func loginWithUsername(username: String, password: String, _ completionHandler: (refreshToken: String?, error: FigoError?) -> Void) {
        request(.LoginUser(username: username, password: password)) { data, error in
            let decoded: (Authorization?, FigoError?) = decodeObject(data)
            self.accessToken = decoded.0?.access_token
            self.refreshToken = decoded.0?.refresh_token
            completionHandler(refreshToken: decoded.0?.refresh_token, error: decoded.1 ?? error)
        }
    }
    
    /**
     EXCHANGE REFRESH TOKEN
     
     Requests new access token with refresh token. New access tokens can be obtained as long
     as the user has not revoked the access granted to your application.
     
     - Parameter refreshToken: The refresh token returned from a previous CREDENTIAL LOGIN
     - parameter completionHandler: Returns nothing or error
     */
    public func loginWithRefreshToken(refreshToken: String, clientID: String, clientSecret: String, _ completionHandler: (error: FigoError?) -> Void) {
        //let secret = base64Encode(clientID, clientSecret)
        request(Endpoint.RefreshToken(token: refreshToken)) { data, error in
            let decoded: (Authorization?, FigoError?) = decodeObject(data)
            self.accessToken = decoded.0?.access_token
            self.refreshToken = decoded.0?.refresh_token
            completionHandler(error: decoded.1 ?? error)
        }
    }
    
    /**
     REVOKE TOKEN
     
     Invalidates the session's access token for simulating an expired access token.
     
     After revoking the access token, with the next API call a new one is fetched automatically if the refresh token is still valid.
     
     - Parameter completionHandler: Returns nothing or error
     */
    public func revokeAccessToken(completionHandler: (error: FigoError?) -> Void) {
        guard let accessToken = self.accessToken else {
            completionHandler(error: FigoError.NoActiveSession)
            return
        }
        request(.RevokeToken(token: accessToken)) { data, error in
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
    public func revokeRefreshToken(refreshToken: String, _ completionHandler: (error: FigoError?) -> Void) {
        request(.RevokeToken(token: refreshToken)) { data, error in
            completionHandler(error: error)
        }
    }
    
}

