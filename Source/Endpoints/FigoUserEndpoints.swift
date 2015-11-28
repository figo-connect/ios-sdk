//
//  FigoUserEndpoints.swift
//  Figo
//
//  Created by Christian König on 28.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


extension FigoSession {
    
    /**
     CREATE NEW FIGO USER
     */
    public func createNewFigoUser(user: NewUser, clientID: String, clientSecret: String, completionHandler: (recoveryPassword: String?, error: FigoError?) -> Void) {
        // let secret = base64Encode(clientID, clientSecret)
        request(Endpoint.CreateNewFigoUser(user: user)) { data, error in
            let JSONObject: ([String: AnyObject]?, FigoError?) = decodeJSON(data)
            if let recoveryPassword: String = JSONObject.0?["recovery_password"] as? String {
                completionHandler(recoveryPassword: recoveryPassword, error: nil)
            } else {
                completionHandler(recoveryPassword: nil, error: JSONObject.1 ?? error)
            }
        }
    }
    
    /**
     RETRIEVE CURRENT USER
     */
    public func retrieveCurrentUser(completionHandler: (user: User?, error: FigoError?) -> Void) {
        request(Endpoint.RetrieveCurrentUser) { data, error in
            let decoded: (User?, FigoError?) = decodeObject(data)
            completionHandler(user: decoded.0, error: decoded.1 ?? error)
        }
    }
}