//
//  Address.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct Address: Unboxable {
    
    public let city: String?
    public let company: String?
    public let postalCode: String?
    public let street: String?
    public let street2: String?
    public let country: String?
    public let vat: Float?
    public let bill: Bool?
    
    public init(unboxer: Unboxer) {
        city        = unboxer.unbox("city")
        company     = unboxer.unbox("company")
        postalCode = unboxer.unbox("postal_code")
        street      = unboxer.unbox("street")
        street2     = unboxer.unbox("street2")
        country     = unboxer.unbox("country")
        vat         = unboxer.unbox("vat")
        bill        = unboxer.unbox("bill")
    }
}

