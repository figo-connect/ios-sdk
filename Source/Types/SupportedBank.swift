//
//  SupportedService.swift
//  Figo
//
//  Created by Christian König on 30.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Unbox


internal struct BanksListEnvelope: Unboxable {

    let banks: [SupportedBank]
    
    init(unboxer: Unboxer) throws {
        banks = try unboxer.unbox(key: "banks")
    }
}


public struct SupportedBank: Unboxable {
    
    public let bankName: String

    public let bankCode: Int?
    
    public let bic: String
    
    public let icon: [AnyObject]
    
    public let credentials: [LoginCredentials]
    
    public let advice: String?
    
    
    public init(unboxer: Unboxer) throws {
        bankName    = try unboxer.unbox(key: "bank_name")
        bankCode    = try unboxer.unbox(key: "bank_code")
        bic         = try unboxer.unbox(key: "bic")
        icon        = try unboxer.unbox(key: "icon")
        credentials = try unboxer.unbox(key: "credentials")
        advice      = try unboxer.unbox(key: "advice")
    }
}

