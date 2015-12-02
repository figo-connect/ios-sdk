//
//  TransactionsEndpoints.swift
//  Figo
//
//  Created by Christian König on 01.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


extension FigoSession {

    /**
     RETRIEVE TRANSACTIONS OF ALL ACCOUNTS
     
     Using this endpoint only returns transactions on accounts that the user has chosen to share with your application.
     
     - Parameter parameters: (optional) `RetrieveTransactionsParameters`
     - Parameter completionHandler: Returns `TransactionListEnvelope` or error
     */
    public func retrieveTransactions(parameters: RetrieveTransactionsParameters? = nil, _ completionHandler: (FigoResult<TransactionListEnvelope>) -> Void) {
        request(.RetrieveTransactions(parameters: parameters)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
    /**
     RETRIEVE TRANSACTIONS OF ONE ACCOUNT
     
     Using this endpoint only returns transactions on accounts that the user has chosen to share with your application.

     - Parameter accountID: The ID of the account for which to retrieve the transactions
     - Parameter parameters: (optional) `RetrieveTransactionsParameters`
     - Parameter completionHandler: Returns `TransactionListEnvelope` or error
     */
    public func retrieveTransactionsForAccount(accountID: String, parameters: RetrieveTransactionsParameters? = nil, _ completionHandler: (FigoResult<TransactionListEnvelope>) -> Void) {
        request(.RetrieveTransactionsForAccount(accountID: accountID, parameters: parameters)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
    /**
     RETRIEVE A TRANSACTION
     
     - Parameter transactionID: ID of the transaction to retrieve
     - Parameter completionHandler: Returns transactions or error
     */
    public func retrieveTransaction(transactionID: String, _ completionHandler: (FigoResult<Transaction>) -> Void) {
        request(.RetrieveTransaction(transactionID: transactionID)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
}