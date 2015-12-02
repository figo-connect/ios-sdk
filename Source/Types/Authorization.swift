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
    
    init(unboxer: Unboxer) {
        accessToken    = unboxer.unbox("access_token")
        expires_in      = unboxer.unbox("expires_in")
        refreshToken   = unboxer.unbox("refresh_token")
        scope           = unboxer.unbox("scope")
        tokenType      = unboxer.unbox("token_type")
    }
}
