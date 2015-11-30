//
//  TanScheme.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct TanScheme: Unboxable  {
    
    public let medium_name: String
    public let name: String
    public let tan_scheme_id: String
    
    
    init(unboxer: Unboxer) {
        medium_name     = unboxer.unbox("medium_name")
        name            = unboxer.unbox("name")
        tan_scheme_id   = unboxer.unbox("tan_scheme_id")
    }
}
