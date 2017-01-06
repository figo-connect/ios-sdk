//
//  FigoUserEndpoints.swift
//  Figo
//
//  Created by Christian König on 28.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Unbox


internal struct RecoveryPasswordEnvelope: Unboxable {
    let recoveryPassword: String
    
    init(unboxer: Unboxer) throws {
        recoveryPassword = try unboxer.unbox(key: "recovery_password")
    }
}


public extension FigoClient {
    
    /**
     CREATE NEW FIGO USER
     */
    public func createNewFigoUser(_ user: CreateUserParameters, clientID: String, clientSecret: String, _ completionHandler: @escaping (Result<String>) -> Void) {
        self.basicAuthCredentials = base64EncodeBasicAuthCredentials(clientID, clientSecret)
        request(Endpoint.createNewFigoUser(user)) { response in
            
            let envelopeUnboxingResult: Result<RecoveryPasswordEnvelope> = decodeUnboxableResponse(response)
            switch envelopeUnboxingResult {
            case .success(let envelope):
                completionHandler(.success(envelope.recoveryPassword))
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
    }
    
    /**
     RETRIEVE CURRENT USER
     */
    public func retrieveCurrentUser(_ completionHandler: @escaping (Result<User>) -> Void) {
        request(Endpoint.retrieveCurrentUser) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
    /**
     DELETE CURRENT USER
     
     Users with an active premium subscription cannot be deleted. The subscription needs to be canceled first.
     */
    public func deleteCurrentUser(_ completionHandler: @escaping VoidCompletionHandler) {
        request(Endpoint.deleteCurrentUser) { response in
            completionHandler(decodeVoidResponse(response))
        }
    }
}
