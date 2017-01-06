//
//  LoginCredentials.swift
//  Figo
//
//  Created by Christian König on 30.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Unbox


public struct LoginCredentials: Unboxable {
    
    /// Label for text input field
    public let label: String?
    
    /// This indicates whether this text input field is used for password entry and therefore should be masked
    public let masked: Bool?
    
    /// This flag indicates whether this text input field is allowed to contain the empty string
    public let optional: Bool?
    
    
    public init(unboxer: Unboxer) throws {
        label = try unboxer.unbox(key: "label")
        masked = try unboxer.unbox(key: "masked")
        optional = try unboxer.unbox(key: "optional")
    }
}
