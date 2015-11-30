//
//  Address.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct Address {
    
    public let city: String?
    public let company: String?
    public let postal_code: String?
    public let street: String?
    public let street2: String?
    public let country: String?
    public let vat: AnyObject?
    public let bill: AnyObject?
}

extension Address: ResponseObjectSerializable {
    
    init(representation: AnyObject) throws {
        let mapper = try Decoder(representation, typeName: "\(self.dynamicType)")
        
        city = try mapper.optionalForKeyName("city")
        company = try mapper.optionalForKeyName("company")
        postal_code = try mapper.optionalForKeyName("postal_code")
        street = try mapper.optionalForKeyName("street")
        street2 = try mapper.optionalForKeyName("street2")
        country = try mapper.optionalForKeyName("country")
        vat = try mapper.optionalForKeyName("vat")
        bill = try mapper.optionalForKeyName("bill")
    }
}

extension Address: ResponseOptionalObjectSerializable {
    
    init?(optionalRepresentation: AnyObject?) throws {
        guard let representation = optionalRepresentation else {
            return nil
        }
        try self.init(representation: representation)
    }
}