//
//  SupportedService.swift
//  Figo
//
//  Created by Christian König on 30.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


internal struct ServicesListEnvelope: Unboxable {
    let services: [SupportedService]
    
    init(unboxer: Unboxer) {
        services = unboxer.unbox("services")
    }
}


public struct SupportedService: Unboxable {
    
    /// Human readable name of the service
    public let name: String
    
    /// surrogate bank code used for this service
    public let bankCode: String
    
    public let additionalIcons: [String: String]
    
    /// URL to an logo of the bank, e.g. as a badge icon
    public let icon: String
    
    
    init(unboxer: Unboxer) {
        name               = unboxer.unbox("name")
        bankCode           = unboxer.unbox("bank_code")
        additionalIcons    = unboxer.unbox("additional_icons")
        icon               = unboxer.unbox("icon")
    }
}

