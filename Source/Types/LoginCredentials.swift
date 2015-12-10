//
//  LoginCredentials.swift
//  Figo
//
//  Created by Christian König on 30.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct LoginCredentials: Unboxable {
    
    /// Label for text input field
    public let label: String
    
    /// This indicates whether the this text input field is used for password entry and therefore should be masked
    public let masked: Bool?
    
    /// This flag indicates whether this text input field is allowed to contain the empty string
    public let optional: Bool?
    
    
    init(unboxer: Unboxer) {
        label = unboxer.unbox("label")
        masked = unboxer.unbox("masked")
        optional = unboxer.unbox("optional")
    }
}
