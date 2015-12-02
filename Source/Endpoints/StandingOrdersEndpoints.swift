//
//  StandingOrdersEndpoints.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


extension FigoSession {
    
    /**
     RETRIEVE STANDING ORDERS OF ALL ACCOUNTS
     
     Using this endpoint only returns standing orders on accounts that the user has chosen to share with your application.
     
     - Parameter completionHandler: Returns standing orders or error
     */
    public func retrieveStandingOrders(completionHandler: (FigoResult<[StandingOrder]>) -> Void) {
        request(.RetrieveStandingOrders) { response in
            
            let unboxingResult: FigoResult<StandingOrderListEnvelope> = decodeUnboxableResponse(response)
            switch unboxingResult {
            case .Success(let envelope):
                completionHandler(FigoResult.Success(envelope.standingOrders))
                break
            case .Failure(let error):
                completionHandler(.Failure(error))
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
    public func retrieveStandingOrdersForAccount(accountID: String, _ completionHandler: (FigoResult<[StandingOrder]>) -> Void) {
        request(.RetrieveStandingOrdersForAccount(accountID)) { response in

            let unboxingResult: FigoResult<StandingOrderListEnvelope> = decodeUnboxableResponse(response)
            switch unboxingResult {
            case .Success(let envelope):
                completionHandler(FigoResult.Success(envelope.standingOrders))
                break
            case .Failure(let error):
                completionHandler(.Failure(error))
                break
            }
        }
    }
    
    /**
     RETRIEVE A STANDING ORDER
     
     - Parameter standingOrderID: ID of the transaction to retrieve
     - Parameter completionHandler: Returns transactions or error
     */
    public func retrieveStandingOrder(standingOrderID: String, _ completionHandler: (FigoResult<StandingOrder>) -> Void) {
        request(.RetrieveStandingOrder(standingOrderID)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
}

