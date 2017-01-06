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
        city        = unboxer.unbox(key: "city")
        company     = unboxer.unbox(key: "company")
        postalCode  = unboxer.unbox(key: "postal_code")
        street      = unboxer.unbox(key: "street")
        street2     = unboxer.unbox(key: "street2")
        country     = unboxer.unbox(key: "country")
        vat         = unboxer.unbox(key: "vat")
        bill        = unboxer.unbox(key: "bill")
    }
}

