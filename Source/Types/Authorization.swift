//
//  Token.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


internal struct Authorization {
    
    var access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
}

extension Authorization: ResponseObjectSerializable {
    
    init(representation: AnyObject) throws {
        let mapper = try Decoder(representation, typeName: "\(self.dynamicType)")
        
        access_token    = try mapper.valueForKeyName("access_token")
        expires_in      = try mapper.valueForKeyName("expires_in")
        refresh_token   = try mapper.optionalForKeyName("refresh_token")
        scope           = try mapper.valueForKeyName("scope")
        token_type      = try mapper.valueForKeyName("token_type")
    }
}