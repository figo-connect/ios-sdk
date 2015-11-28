//
//  Balance.swift
//  Figo
//
//  Created by Christian König on 24.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct Balance {
    
    /// Account balance in cents; This response parameter will be omitted if the balance is not yet known
    let balance: Int?
    
    /// Bank server timestamp of balance; This response parameter will be omitted if the balance is not yet known
    let balance_date: String?
    
    /// Credit line
    let credit_line: Float
    
    /// User-defined spending limit
    let monthly_spending_limit: Float
    
    /// Synchronization status object.
    let status: SyncStatus?
}

extension Balance: ResponseObjectSerializable {

    public init(representation: AnyObject) throws {
        let mapper = try Decoder(representation, typeName: "\(self.dynamicType)")
        
        balance                 = try mapper.optionalForKeyName("balance")
        balance_date            = try mapper.optionalForKeyName("balance_date")
        credit_line             = try mapper.valueForKeyName("credit_line")
        monthly_spending_limit  = try mapper.valueForKeyName("monthly_spending_limit")
        status                  = try SyncStatus(optionalRepresentation: mapper.optionalForKeyName("status"))
    }
}

extension Balance: ResponseOptionalObjectSerializable {
    
    public init?(optionalRepresentation: AnyObject?) throws {
        guard let representation = optionalRepresentation else {
            return nil
        }
        try self.init(representation: representation)
    }
}