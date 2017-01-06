//
//  SupportedService.swift
//  Figo
//
//  Created by Christian König on 30.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


internal struct ServicesListEnvelope: Unboxable {
    let services: [SupportedService]
    
    init(unboxer: Unboxer) throws {
        services = try unboxer.unbox(key: "services")
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
    
    
    public init(unboxer: Unboxer) throws {
        name               = try unboxer.unbox(key: "name")
        bankCode           = try unboxer.unbox(key: "bank_code")
        additionalIcons    = try unboxer.unbox(key: "additional_icons")
        icon               = try unboxer.unbox(key: "icon")
    }
}

