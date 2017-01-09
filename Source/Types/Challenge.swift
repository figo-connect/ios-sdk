//
//  Challenge.swift
//  Figo
//
//  Created by Christian König on 26.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


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
        title   = unboxer.unbox(key: "title")
        label   = unboxer.unbox(key: "label")
        format  = unboxer.unbox(key: "format")
        data    = unboxer.unbox(key: "data")
    }
}
