//
//  BankAccountEndpoints.swift
//  Figo
//
//  Created by Christian König on 27.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


extension FigoSession {
    
    /**
     RETRIEVE ALL BANK ACCOUNTS
     
     This only returns the bank accounts the user has chosen to share with your application
     
     - Parameter completionHandler: Returns accounts or error
     */
    public func retrieveAccounts(completionHandler: (accounts: [Account]?, error: FigoError?) -> Void) {
        request(.RetrieveAccounts) { data, error in
            let decoded: ([Account]?, FigoError?) = decodeCollection(data)
            completionHandler(accounts: decoded.0, error: decoded.1 ?? error)
        }
    }
    
    /**
     RETRIEVE A BANK ACCOUNT
     
     - Parameter accountID: Internal figo Connect account ID
     - Parameter completionHandler: Returns account or error
    */
    public func retrieveAccount(accountID: String, _ completionHandler: (account: Account?, error: FigoError?) -> Void) {
        request(Endpoint.RetrieveAccount(accountId: accountID)) { data, error in
            let decoded: (Account?, FigoError?) = decodeObject(data)
            completionHandler(account: decoded.0, error: decoded.1 ?? error)
        }
    }
    
    /**
     REMOVE STORED PIN FROM BANK CONTACT
     
     Removes the stored PIN of a bank contact from the figo Connect server
     
     - Parameter bankIdenitifier Internal ID of the bank
     - Parameter completionHandler: Returns nothing or error
    */
    public func removeStoredPinFromBankContact(bankIdenitifier: String, _ completionHandler: (error: FigoError?) -> Void) {
        request(.RemoveStoredPin(bankId: bankIdenitifier)) { (data, error) -> Void in
            completionHandler(error: error)
        }
    }
}

