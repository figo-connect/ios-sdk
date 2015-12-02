//
//  TANScheme.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct TANScheme: Unboxable  {
    
    public let mediumName: String
    public let name: String
    public let TANSchemeID: String
    
    
    init(unboxer: Unboxer) {
        mediumName     = unboxer.unbox("medium_name")
        name            = unboxer.unbox("name")
        TANSchemeID   = unboxer.unbox("tan_scheme_id")
    }
}
