//
//  SecuritiesEndpoints.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


extension FigoSession {
    
    /**
     RETRIEVE SECURITIES OF ALL ACCOUNTS
     
     Using this endpoint only returns transactions on accounts that the user has chosen to share with your application.
     
     - Parameter parameters: (optional) `RetrieveSecuritiesParameters`
     - Parameter completionHandler: Returns `SecurityListEnvelope` or error
     */
    public func retrieveSecurities(parameters: RetrieveSecuritiesParameters? = nil, _ completionHandler: (FigoResult<SecurityListEnvelope>) -> Void) {
        request(.RetrieveSecurities(parameters: parameters)) { response in
            
            let envelopeUnboxingResult: FigoResult<SecurityListEnvelope> = decodeUnboxableResponse(response)
            completionHandler(envelopeUnboxingResult)
        }
    }
    
    /**
     RETRIEVE SECURITIES OF ONE ACCOUNT
     
     Using this endpoint only returns transactions on accounts that the user has chosen to share with your application.
     
     - Parameter accountID: The ID of the account for which to retrieve the securities
     - Parameter parameters: (optional) `RetrieveSecuritiesParameters`
     - Parameter completionHandler: Returns `SecurityListEnvelope` or error
     */
    public func retrieveSecuritiesForAccount(accountID: String, parameters: RetrieveSecuritiesParameters? = nil, _ completionHandler: (FigoResult<SecurityListEnvelope>) -> Void) {
        request(.RetrieveSecuritiesForAccount(accountID: accountID, parameters: parameters)) { response in
            
            let envelopeUnboxingResult: FigoResult<SecurityListEnvelope> = decodeUnboxableResponse(response)
            completionHandler(envelopeUnboxingResult)
        }
    }
    
    /**
     RETRIEVE A SECURITY

     - Parameter accountID: ID of the account the security belongs to
     - Parameter securityID: ID of the transaction to retrieve
     - Parameter completionHandler: Returns security or error
     */
    public func retrieveSecurity(accountID accountID: String, securityID: String, _ completionHandler: (FigoResult<Security>) -> Void) {
        request(.RetrieveSecurity(accountID: accountID, securityID: securityID)) { response in
            
            let unboxingResult: FigoResult<Security> = decodeUnboxableResponse(response)
            completionHandler(unboxingResult)
        }
    }
    
}
