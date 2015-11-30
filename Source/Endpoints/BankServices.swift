//
//  BankServices.swift
//  Figo
//
//  Created by Christian König on 30.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation



extension FigoSession {
    
    /**
     RETRIEVE LOGIN SETTINGS FOR A BANK OR SERVICE
     
     This only returns the bank accounts the user has chosen to share with your application
     
     - Parameter countryCode: The country the service comes from (Valid values: de)
     - Parameter bankCode: Bank code
     - Parameter completionHandler: Returns login settings or error
     */
    public func retrieveLoginSettings(countryCode: String = "de", bankCode: String, _ completionHandler: (FigoResult<LoginSettings>) -> Void) {
        request(Endpoint.RetrieveLoginSettings(countryCode: countryCode, bankCode: bankCode)) { response in
            let decoded: FigoResult<LoginSettings> = decodeObjectResponse(response)
            completionHandler(decoded)
        }
    }
}