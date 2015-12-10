//
//  Balance.swift
//  Figo
//
//  Created by Christian König on 24.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct Balance: Unboxable {
    
    /// Account balance in cents; This response parameter will be omitted if the balance is not yet known
    public let balance: Int?
    
    /// Bank server timestamp of balance; This response parameter will be omitted if the balance is not yet known
    public let balanceDate: Date?
    
    /// Credit line
    public let creditLine: Float
    
    /// User-defined spending limit
    public let monthlySpendingLimit: Float
    
    /// Synchronization status object.
    public let status: SyncStatus?
    
    
    public init(unboxer: Unboxer) {
        balance                 = unboxer.unbox("balance")
        balanceDate             = unboxer.unbox("balance_date")
        creditLine              = unboxer.unbox("credit_line")
        monthlySpendingLimit    = unboxer.unbox("monthly_spending_limit")
        status                  = unboxer.unbox("status")
        
    }
}
