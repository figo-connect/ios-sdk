//
//  SupportedService.swift
//  Figo
//
//  Created by Christian König on 30.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct SupportedBank: Unboxable {
    
    public let bank_name: String

    public let bank_code: Int
    
    public let bic: String
    
    public let icon: [AnyObject]
    
    public let credentials: [LoginCredentials]
    
    public let advice: String
    
    
    init(unboxer: Unboxer) {
        bank_name   = unboxer.unbox("bank_name")
        bank_code   = unboxer.unbox("bank_code")
        bic         = unboxer.unbox("bic")
        icon        = unboxer.unbox("icon")
        credentials = unboxer.unbox("credentials")
        advice      = unboxer.unbox("advice")
    }
}

