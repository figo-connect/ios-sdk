//
//  Challenge.swift
//  Figo
//
//  Created by Christian König on 26.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Unbox


public struct Challenge: Unboxable {
    
    /// Challenge title
    public let title: String?
    
    /// Response label
    public let label: String?
    
    /// Challenge data format. Possible values are Text, HTML, HHD or Matrix.
    public let format: String?
    
    /// Challenge data
    public let data: String?
    
    
    public init(unboxer: Unboxer) throws {
        title   = try unboxer.unbox(key: "title")
        label   = try unboxer.unbox(key: "label")
        format  = try unboxer.unbox(key: "format")
        data    = try unboxer.unbox(key: "data")
    }
}
