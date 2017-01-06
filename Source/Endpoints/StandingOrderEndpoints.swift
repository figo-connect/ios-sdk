//
//  StandingOrderEndpoints.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public extension FigoClient {
    
    /**
     RETRIEVE STANDING ORDERS OF ALL ACCOUNTS
     
     Using this endpoint only returns standing orders on accounts that the user has chosen to share with your application.
     
     - Parameter completionHandler: Returns standing orders or error
     */
    public func retrieveStandingOrders(_ completionHandler: @escaping (Result<[StandingOrder]>) -> Void) {
        request(.retrieveStandingOrders) { response in
            
            let unboxingResult: Result<StandingOrderListEnvelope> = decodeUnboxableResponse(response)
            switch unboxingResult {
            case .success(let envelope):
                completionHandler(Result.success(envelope.standingOrders))
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
    }
    
    /**
     RETRIEVE STANDING ORDERS OF ONE ACCOUNT
     
     Using this endpoint only returns standing orders on accounts that the user has chosen to share with your application.
     
     - Parameter accountID: The ID of the account for which to retrieve the standing orders
     - Parameter completionHandler: Returns standing orders or error
     */
    public func retrieveStandingOrdersForAccount(_ accountID: String, _ completionHandler: @escaping (Result<[StandingOrder]>) -> Void) {
        request(.retrieveStandingOrdersForAccount(accountID)) { response in

            let unboxingResult: Result<StandingOrderListEnvelope> = decodeUnboxableResponse(response)
            switch unboxingResult {
            case .success(let envelope):
                completionHandler(Result.success(envelope.standingOrders))
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
    }
    
    /**
     RETRIEVE A STANDING ORDER
     
     - Parameter standingOrderID: ID of the transaction to retrieve
     - Parameter completionHandler: Returns transactions or error
     */
    public func retrieveStandingOrder(_ standingOrderID: String, _ completionHandler: @escaping (Result<StandingOrder>) -> Void) {
        request(.retrieveStandingOrder(standingOrderID)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
}

