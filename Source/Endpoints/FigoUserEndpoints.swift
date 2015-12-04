//
//  FigoUserEndpoints.swift
//  Figo
//
//  Created by Christian König on 28.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


internal struct RecoveryPasswordEnvelope: Unboxable {
    let recoveryPassword: String
    
    init(unboxer: Unboxer) {
        recoveryPassword = unboxer.unbox("recovery_password")
    }
}


public extension FigoClient {
    
    /**
     CREATE NEW FIGO USER
     */
    public func createNewFigoUser(user: CreateUserParameters, clientID: String, clientSecret: String, _ completionHandler: (Result<String>) -> Void) {
        self.basicAuthCredentials = base64EncodeBasicAuthCredentials(clientID, clientSecret)
        request(Endpoint.CreateNewFigoUser(user)) { response in
            
            let envelopeUnboxingResult: Result<RecoveryPasswordEnvelope> = decodeUnboxableResponse(response)
            switch envelopeUnboxingResult {
            case .Success(let envelope):
                completionHandler(.Success(envelope.recoveryPassword))
                break
            case .Failure(let error):
                completionHandler(.Failure(error))
                break
            }
        }
    }
    
    /**
     RETRIEVE CURRENT USER
     */
    public func retrieveCurrentUser(completionHandler: (Result<User>) -> Void) {
        request(Endpoint.RetrieveCurrentUser) { response in
            completionHandler(decodeUnboxableResponse(response))
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
