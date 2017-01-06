//
//  TANScheme.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Unbox


public struct TANScheme: Unboxable  {
    
    public let mediumName: String
    public let name: String
    public let TANSchemeID: String
    
    
    public init(unboxer: Unboxer) throws {
        mediumName    = try unboxer.unbox(key: "medium_name")
        name          = try unboxer.unbox(key: "name")
        TANSchemeID   = try unboxer.unbox(key: "tan_scheme_id")
    }
}
