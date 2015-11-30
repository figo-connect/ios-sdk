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
    public let balance_date: String?
    
    /// Credit line
    public let credit_line: Float
    
    /// User-defined spending limit
    public let monthly_spending_limit: Float
    
    /// Synchronization status object.
    public let status: SyncStatus?
    
    
    init(unboxer: Unboxer) {
        balance                 = unboxer.unbox("balance")
        balance_date            = unboxer.unbox("balance_date")
        credit_line             = unboxer.unbox("credit_line")
        monthly_spending_limit  = unboxer.unbox("monthly_spending_limit")
        status                  = unboxer.unbox("status")
        
    }
}
