//
//  Balance.swift
//  Figo
//
//  Created by Christian König on 24.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Unbox


public struct Balance: Unboxable {
    
    /// Account balance in cents; This response parameter will be omitted if the balance is not yet known
    public let balance: Int?
    
    /// Bank server timestamp of balance; This response parameter will be omitted if the balance is not yet known
    public let balanceDate: FigoDate?
    
    /// Credit line
    public let creditLine: Float
    
    /// User-defined spending limit
    public let monthlySpendingLimit: Float
    
    /// Synchronization status object.
    public let status: SyncStatus?
    
    
    public init(unboxer: Unboxer) throws {
        balance                 = unboxer.unbox(key: "balance")
        balanceDate             = unboxer.unbox(key: "balance_date")
        creditLine              = try unboxer.unbox(key: "credit_line")
        monthlySpendingLimit    = try unboxer.unbox(key: "monthly_spending_limit")
        status                  = unboxer.unbox(key: "status")
        
    }
}
