//
//  LoginSettings.swift
//  Figo
//
//  Created by Christian König on 28.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct LoginSettings {
    
    /// Human readable name of the bank
    let bank_name: String
    
    /// Flag showing whether figo supports the bank
    let supported: Bool
    
    /// URL to an logo of the bank, e.g. as a badge icon
    let icon: String
    
    /// Dictionary mapping from resolution to URL for additional resolutions of the banks icon. Currently supports 48x48 and 60x60.
    let additional_icons: [String: String]

    /// List of credentials needed to connect to the bank.
    let credentials: [LoginCredentials]
    
    /// Kind of authentication used by the bank, commonly PIN
    let auth_type: String
    
    /// Any additional advice useful to locate the required credentials
    let advice: String?
}

extension LoginSettings: ResponseObjectSerializable {
    
    public init(representation: AnyObject) throws {
        let mapper = try Decoder(representation, typeName: "\(self.dynamicType)")
        
        bank_name           = try mapper.valueForKeyName("bank_name")
        supported           = try mapper.valueForKeyName("supported")
        icon                = try mapper.valueForKeyName("icon")
        additional_icons    = try mapper.valueForKeyName("additional_icons")
        credentials         = try LoginCredentials.collection(mapper.valueForKeyName("credentials"))
        auth_type           = try mapper.valueForKeyName("auth_type")
        advice              = try mapper.optionalForKeyName("advice")
    }
}

public struct LoginCredentials {
    
    /// Label for text input field
    let label: String

    /// This indicates whether the this text input field is used for password entry and therefore should be masked
    let masked: Bool?
    
    /// This flag indicates whether this text input field is allowed to contain the empty string
    let optional: Bool?
}

extension LoginCredentials: ResponseObjectSerializable {
    
    public init(representation: AnyObject) throws {
        let mapper = try Decoder(representation, typeName: "\(self.dynamicType)")
        
        label   = try mapper.valueForKeyName("label")
        masked   = try mapper.optionalForKeyName("masked")
        optional  = try mapper.optionalForKeyName("optional")
    }
}

extension LoginCredentials: ResponseCollectionSerializable {
    
    public static func collection(representation: AnyObject) throws -> [LoginCredentials] {
        var accounts: [LoginCredentials] = []
        if let representation = representation as? [String: AnyObject] {
            let account = try LoginCredentials(representation: representation)
            accounts.append(account)
        }
        return accounts
    }
}