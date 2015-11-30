//
//  Token.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


internal struct Authorization: Unboxable {
    
    var access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
    
    
    init(unboxer: Unboxer) {
        access_token    = unboxer.unbox("access_token")
        expires_in      = unboxer.unbox("expires_in")
        refresh_token   = unboxer.unbox("refresh_token")
        scope           = unboxer.unbox("scope")
        token_type      = unboxer.unbox("token_type")
    }
}
