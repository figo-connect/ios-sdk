//
//  Balance.swift
//  Figo
//
//  Created by Christian König on 24.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public struct Balance: JSONObjectConvertible, ResponseObjectSerializable {
    
    let balance: Float
    let balance_date: String
    let credit_line: Float
    let monthly_spending_limit: Float
    
    private enum Key: String, PropertyKey {
        case balance
        case balance_date
        case credit_line
        case monthly_spending_limit
    }
    
    public init(representation: AnyObject) throws {
        let mapper = try Decoder(representation, typeName: "\(self.dynamicType)")
        
        balance = try mapper.valueForKey(Key.balance)
        balance_date = try mapper.valueForKey(Key.balance_date)
        credit_line = try mapper.valueForKey(Key.credit_line)
        monthly_spending_limit = try mapper.valueForKey(Key.monthly_spending_limit)
    }
    
    public var JSONObject: [String: AnyObject] {
        get {
            var dict = Dictionary<String, AnyObject>()
            dict[Key.balance.rawValue] = balance
            dict[Key.balance_date.rawValue] = balance_date
            dict[Key.credit_line.rawValue] = credit_line
            dict[Key.monthly_spending_limit.rawValue] = monthly_spending_limit
            return dict
        }
    }
    
    public var description: String {
        get {
            return JSONStringFromType(self)
        }
    }
}
