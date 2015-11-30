//
//  SupportedService.swift
//  Figo
//
//  Created by Christian König on 30.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct SupportedService: Unboxable {
    
    /// Human readable name of the service
    public let name: String
    
    /// surrogate bank code used for this service
    public let bank_code: String
    
    public let additional_icons: [String: String]
    
    /// URL to an logo of the bank, e.g. as a badge icon
    public let icon: String
    
    
    init(unboxer: Unboxer) {
        name                = unboxer.unbox("name")
        bank_code           = unboxer.unbox("bank_code")
        additional_icons    = unboxer.unbox("additional_icons")
        icon                = unboxer.unbox("icon")
    }
}

