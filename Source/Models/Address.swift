//
//  Address.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public struct Address {
    
    let city: String
    let company: String
    let postal_code: String
    let street: String
    
    private enum Key: String, PropertyKey {
        case bill
        case city
        case company
        case country
        case postal_code
        case street
        case street2
        case vat
    }
    
    public init?(representation: AnyObject?) throws {
        guard let representation = representation else {
            return nil
        }
        let mapper = try PropertyMapper(representation, typeName: "\(self.dynamicType)")
        
        city = try mapper.valueForKey(Key.city)
        company = try mapper.valueForKey(Key.company)
        postal_code = try mapper.valueForKey(Key.postal_code)
        street = try mapper.valueForKey(Key.street)
    }
}