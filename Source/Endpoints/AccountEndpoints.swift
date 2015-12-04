//
//  AccountEndpoints.swift
//  Figo
//
//  Created by Christian König on 27.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public extension FigoClient {
    
    /**
     RETRIEVE ALL BANK ACCOUNTS
     
     This only returns the bank accounts the user has chosen to share with your application
     
     - Parameter completionHandler: Returns accounts or error
     */
    public func retrieveAccounts(completionHandler: (Result<[Account]>) -> Void) {
        request(.RetrieveAccounts) { response in
            
            let envelopeUnboxingResult: Result<AccountListEnvelope> = decodeUnboxableResponse(response)
            switch envelopeUnboxingResult {
            case .Success(let envelope):
                completionHandler(.Success(envelope.accounts))
                break
            case .Failure(let error):
                completionHandler(.Failure(error))
                break
            }
        }
    }
    
    /**
     RETRIEVE A BANK ACCOUNT
     
     - Parameter accountID: Internal figo Connect account ID
     - Parameter completionHandler: Returns account or error
    */
    public func retrieveAccount(accountID: String, _ completionHandler: (Result<Account>) -> Void) {
        request(.RetrieveAccount(accountID)) { response in
            let decoded: Result<Account> = decodeUnboxableResponse(response)
            completionHandler(decoded)
        }
    }
    
    /**
     REMOVE STORED PIN FROM BANK CONTACT
     
     Removes the stored PIN of a bank contact from the figo Connect server
     
     - Parameter bankID Internal ID of the bank
     - Parameter completionHandler: Returns nothing or error
    */
    public func removeStoredPinFromBankContact(bankID: String, _ completionHandler: VoidCompletionHandler) {
        request(.RemoveStoredPin(bankID: bankID)) { response in
            completionHandler(decodeVoidResponse(response))
        }
    }
    
    /**
     SETUP NEW BANK ACCOUNT
     
     The figo Connect server will transparently create or modify a bank contact to add additional bank accounts.

     - Parameter parameters: CreateAccountParameters
     - Parameter progressHandler: (optional) Is called periodically with a message from the server
     - Parameter completionHandler: Returns nothing or error
     */
    public func setupNewBankAccount(parameters: CreateAccountParameters, progressHandler: ProgressUpdate?, _ completionHandler: VoidCompletionHandler) {
        request(.SetupAccount(parameters)) { response in
            
            let unboxingResult: Result<TaskTokenEvelope> = decodeUnboxableResponse(response)
            switch unboxingResult {
            case .Success(let envelope):
                
                let nextParameters = PollTaskStateParameters(taskToken: envelope.taskToken)
                self.pollTaskState(nextParameters, POLLING_COUNTDOWN_INITIAL_VALUE, progressHandler, nil, nil) { result in
                    completionHandler(result)
                }
                break
            case .Failure(let error):
                
                completionHandler(.Failure(error))
                break
            }
        }
        
    }
    
    /**
     DELETE BANK ACCOUNT
     
     Once the last remaining account of a bank contact has been removed, the bank contact will be automatically removed as well
     */
    public func deleteAccount(accountID: String, _ completionHandler: VoidCompletionHandler) {
        request(.DeleteAccount(accountID)) { response in
            completionHandler(decodeVoidResponse(response))
        }
    }
    
}




