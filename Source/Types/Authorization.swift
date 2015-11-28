//
//  Token.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public final class Authorization: ResponseObjectSerializable {
    
    var access_token: String?
    let expires_in: Int?
    let refresh_token: String?
    let scope: String?
    let token_type: String?
    
    public init(representation: AnyObject) throws {
        access_token = representation.valueForKeyPath("access_token") as? String
        expires_in = representation.valueForKeyPath("access_token") as? Int
        refresh_token = representation.valueForKeyPath("refresh_token") as? String
        scope = representation.valueForKeyPath("scope") as? String
        token_type = representation.valueForKeyPath("token_type") as? String
    }
    
    public init(token: String) {
        access_token = nil
        expires_in = nil
        refresh_token = token
        scope = nil
        token_type = nil
    }
    
}