//
//  Challenge.swift
//  Figo
//
//  Created by Christian König on 26.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public struct Challenge {
    
    /// Challenge title
    let title: String
    
    /// Response label
    let label: String
    
    /// Challenge data format. Possible values are Text, HTML, HHD or Matrix.
    let format: String
    
    /// Challenge data
    let data: String?
}

extension Challenge: ResponseObjectSerializable {
    
    public init(representation: AnyObject) throws {
        let mapper = try Decoder(representation, typeName: "\(self.dynamicType)")
        
        title   = try mapper.valueForKeyName("title")
        label   = try mapper.valueForKeyName("label")
        format  = try mapper.valueForKeyName("format")
        data    = try mapper.valueForKeyName("data")
    }
}

extension Challenge: ResponseOptionalObjectSerializable {
    
    public init?(optionalRepresentation: AnyObject?) throws {
        guard let representation = optionalRepresentation else {
            return nil
        }
        try self.init(representation: representation)
    }
}