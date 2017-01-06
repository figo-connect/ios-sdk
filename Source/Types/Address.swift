//
//  Address.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Unbox


public struct Address: Unboxable {
    
    public let city: String?
    public let company: String?
    public let postalCode: String?
    public let street: String?
    public let street2: String?
    public let country: String?
    public let vat: Float?
    public let bill: Bool?
    
    public init(unboxer: Unboxer) throws {
        city        = try unboxer.unbox(key: "city")
        company     = try unboxer.unbox(key: "company")
        postalCode = try unboxer.unbox(key: "postal_code")
        street      = try unboxer.unbox(key: "street")
        street2     = try unboxer.unbox(key: "street2")
        country     = try unboxer.unbox(key: "country")
        vat         = try unboxer.unbox(key: "vat")
        bill        = try unboxer.unbox(key: "bill")
    }
}

