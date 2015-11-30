//
//  LoginCredentials.swift
//  Figo
//
//  Created by Christian König on 30.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


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