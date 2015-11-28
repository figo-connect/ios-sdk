//
//  Challenge.swift
//  Figo
//
//  Created by Christian König on 26.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public struct Challenge: ResponseObjectSerializable {
    
    /// Challenge title
    let title: String
    
    /// Response label
    let label: String
    
    /// Challenge data format. Possible values are Text, HTML, HHD or Matrix.
    let format: String
    
    /// Challenge data
    let data: String?
    
    private enum Key: String, PropertyKey {
        case title
        case label
        case format
        case data
    }
    
    public init(representation: AnyObject) throws {
        let mapper = try Decoder(representation, typeName: "\(self.dynamicType)")
        
        title   = try mapper.valueForKey(Key.title)
        label   = try mapper.valueForKey(Key.label)
        format  = try mapper.valueForKey(Key.format)
        data    = try mapper.valueForKey(Key.data)
    }
}
