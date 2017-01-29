//
//  AccountEndpoints.swift
//  Figo
//
//  Created by Christian König on 27.11.15.
//  Copyright © 2015 figo GmbH. All rights reserved.
//


public extension FigoClient {
    
    /**
     RETRIEVE ALL BANK ACCOUNTS
     
     This only returns the bank accounts the user has chosen to share with your application
     
     - Parameter completionHandler: Returns accounts or error
     */
    public func retrieveAccounts(_ completionHandler: @escaping (FigoResult<[Account]>) -> Void) {
        request(.retrieveAccounts) { response in
            
            let envelopeUnboxingResult: FigoResult<AccountListEnvelope> = decodeUnboxableResponse(response)
            switch envelopeUnboxingResult {
            case .success(let envelope):
                completionHandler(.success(envelope.accounts))
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
    }
    
    /**
     RETRIEVE A BANK ACCOUNT
     
     - Parameter accountID: Internal figo Connect account ID
     - Parameter completionHandler: Returns account or error
    */
    public func retrieveAccount(_ accountID: String, _ completionHandler: @escaping (FigoResult<Account>) -> Void) {
        request(.retrieveAccount(accountID)) { response in
            let decoded: FigoResult<Account> = decodeUnboxableResponse(response)
            completionHandler(decoded)
        }
    }
    
    /**
     REMOVE STORED PIN FROM BANK CONTACT
     
     Removes the stored PIN of a bank contact from the figo Connect server
     
     - Parameter bankID Internal ID of the bank
     - Parameter completionHandler: Returns nothing or error
    */
    public func removeStoredPinFromBankContact(_ bankID: String, _ completionHandler: @escaping VoidCompletionHandler) {
        request(.removeStoredPin(bankID: bankID)) { response in
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
    public func setupNewBankAccount(_ parameters: CreateAccountParameters, progressHandler: ProgressUpdate? = nil, _ completionHandler: @escaping VoidCompletionHandler) {
        request(.setupAccount(parameters)) { response in
            
            let unboxingResult: FigoResult<TaskTokenEvelope> = decodeUnboxableResponse(response)
            switch unboxingResult {
            case .success(let envelope):
                
                let nextParameters = PollTaskStateParameters(taskToken: envelope.taskToken)
                self.pollTaskState(nextParameters, POLLING_COUNTDOWN_INITIAL_VALUE, progressHandler, nil, nil) { result in
                    completionHandler(result)
                }
                break
            case .failure(let error):
                
                completionHandler(.failure(error))
                break
            }
        }
        
    }
    
    /**
     DELETE BANK ACCOUNT
     
     Once the last remaining account of a bank contact has been removed, the bank contact will be automatically removed as well
     */
    public func deleteAccount(_ accountID: String, _ completionHandler: @escaping VoidCompletionHandler) {
        request(.deleteAccount(accountID)) { response in
            completionHandler(decodeVoidResponse(response))
        }
    }
    
}




