//
//  LoginSettings.swift
//  Figo
//
//  Created by Christian König on 28.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct LoginSettings: Unboxable {
    
    /// Human readable name of the bank
    public let bankName: String
    
    /// Flag showing whether figo supports the bank
    public let supported: Bool
    
    /// URL to an logo of the bank, e.g. as a badge icon
    public let icon: String
    
    /// Dictionary mapping from resolution to URL for additional resolutions of the banks icon. Currently supports 48x48 and 60x60.
    public let additional_icons: [String: String]

    /// List of credentials needed to connect to the bank.
    public let credentials: [LoginCredentials]
    
    /// Kind of authentication used by the bank, commonly PIN
    public let authType: String
    
    /// Any additional advice useful to locate the required credentials
    public let advice: String?
    
    
    init(unboxer: Unboxer) {
        bankName            = unboxer.unbox("bank_name")
        supported           = unboxer.unbox("supported")
        icon                = unboxer.unbox("icon")
        additional_icons    = unboxer.unbox("additional_icons")
        credentials         = unboxer.unbox("credentials")
        authType            = unboxer.unbox("auth_type")
        advice              = unboxer.unbox("advice")
    }
}
