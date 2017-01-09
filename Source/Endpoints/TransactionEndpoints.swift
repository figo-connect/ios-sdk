//
//  TransactionEndpoints.swift
//  Figo
//
//  Created by Christian König on 01.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public extension FigoClient {

    /**
     RETRIEVE TRANSACTIONS OF ALL ACCOUNTS
     
     Using this endpoint only returns transactions on accounts that the user has chosen to share with your application.
     
     - Parameter parameters: (optional) `RetrieveTransactionsParameters`
     - Parameter completionHandler: Returns `TransactionListEnvelope` or error
     */
    public func retrieveTransactions(_ parameters: RetrieveTransactionsParameters = RetrieveTransactionsParameters(), _ completionHandler: @escaping (Result<TransactionListEnvelope>) -> Void) {
        request(.retrieveTransactions(parameters)) { response in
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
    public func retrieveTransactionsForAccount(_ accountID: String, parameters: RetrieveTransactionsParameters = RetrieveTransactionsParameters(), _ completionHandler: @escaping (Result<TransactionListEnvelope>) -> Void) {
        request(.retrieveTransactionsForAccount(accountID, parameters: parameters)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
    /**
     RETRIEVE A TRANSACTION
     
     - Parameter transactionID: ID of the transaction to retrieve
     - Parameter completionHandler: Returns transactions or error
     */
    public func retrieveTransaction(_ transactionID: String, _ completionHandler: @escaping (Result<Transaction>) -> Void) {
        request(.retrieveTransaction(transactionID)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
}

