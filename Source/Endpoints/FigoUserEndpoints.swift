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
    public func createNewFigoUser(user: CreateUserParameters, clientID: String, clientSecret: String, _ completionHandler: (FigoResult<String>) -> Void) {
        self.basicAuthSecret = base64Encode(clientID, clientSecret)
        request(Endpoint.CreateNewFigoUser(user: user)) { response in
            let decoded = decodeJSONResponse(response)
            switch decoded {
            case .Failure(let error):
                completionHandler(.Failure(error))
                break
            case .Success(let JSONObject):
                if let recoveryPassword: String = JSONObject["recovery_password"] as? String {
                    completionHandler(.Success(recoveryPassword))
                } else {
                    completionHandler(.Failure(.JSONMissingMandatoryKey(key: "recovery_password", typeName: "JSONResponse")))
                }
                break
            }
        }
    }
    
    /**
     RETRIEVE CURRENT USER
     */
    public func retrieveCurrentUser(completionHandler: (FigoResult<User>) -> Void) {
        request(Endpoint.RetrieveCurrentUser) { response in
            let decoded: FigoResult<User> = responseUnboxed(response)
            completionHandler(decoded)
        }
    }
    
    /**
     DELETE CURRENT USER
     
     Users with an active premium subscription cannot be deleted. The subscription needs to be canceled first.
     */
    public func deleteCurrentUser(completionHandler: VoidCompletionHandler) {
        request(Endpoint.DeleteCurrentUser) { response in
            completionHandler(decodeVoidResponse(response))
        }
    }
}
