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
    
    
    init(unboxer: Unboxer) {
        title   = unboxer.unbox("title")
        label   = unboxer.unbox("label")
        format  = unboxer.unbox("format")
        data    = unboxer.unbox("data")
    }
}
