//
//  Token.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


internal struct Authorization: Unboxable {
    
    var accessToken: String
    let expires_in: Int
    let refreshToken: String?
    let scope: String
    let tokenType: String
    
    init(unboxer: Unboxer) throws {
        accessToken    = try unboxer.unbox(key: "access_token")
        expires_in     = try unboxer.unbox(key: "expires_in")
        refreshToken   = unboxer.unbox(key: "refresh_token")
        scope          = try unboxer.unbox(key: "scope")
        tokenType      = try unboxer.unbox(key: "token_type")
    }
}
