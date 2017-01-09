//
//  SecurityEndpoints.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public extension FigoClient {
    
    /**
     RETRIEVE SECURITIES OF ALL ACCOUNTS
     
     Using this endpoint only returns securities on accounts that the user has chosen to share with your application.
     
     - Parameter parameters: (optional) `RetrieveSecuritiesParameters`
     - Parameter completionHandler: Returns `SecurityListEnvelope` or error
     */
    public func retrieveSecurities(_ parameters: RetrieveSecuritiesParameters = RetrieveSecuritiesParameters(), _ completionHandler: @escaping (Result<SecurityListEnvelope>) -> Void) {
        request(.retrieveSecurities(parameters)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
    /**
     RETRIEVE SECURITIES OF ONE ACCOUNT
     
     Using this endpoint only returns securities on accounts that the user has chosen to share with your application.
     
     - Parameter accountID: The ID of the account for which to retrieve the securities
     - Parameter parameters: (optional) `RetrieveSecuritiesParameters`
     - Parameter completionHandler: Returns `SecurityListEnvelope` or error
     */
    public func retrieveSecuritiesForAccount(_ accountID: String, parameters: RetrieveSecuritiesParameters = RetrieveSecuritiesParameters(), _ completionHandler: @escaping (Result<SecurityListEnvelope>) -> Void) {
        request(.retrieveSecuritiesForAccount(accountID, parameters: parameters)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
    /**
     RETRIEVE A SECURITY

     - Parameter securityID: ID of the securitiy to retrieve
     - Parameter accountID: ID of the account the security belongs to
     - Parameter completionHandler: Returns security or error
     */
    public func retrieveSecurity(_ securityID: String, accountID: String, _ completionHandler: @escaping (Result<Security>) -> Void) {
        request(.retrieveSecurity(securityID, accountID: accountID)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
}
