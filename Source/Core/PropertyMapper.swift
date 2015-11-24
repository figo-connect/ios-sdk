//
//  PropertyMapper.swift
//  Figo
//
//  Created by Christian König on 24.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


protocol JSONObjectConvertible {
    var JSONObject: [String: AnyObject] { get }
}


struct PropertyMapper {
    
    let representation: AnyObject
    
    init(representation: AnyObject) {
        self.representation = representation
    }
    
    func stringForKey(key: String, representation: AnyObject) throws -> String {
        if let value = representation.valueForKeyPath(key) as? String {
            return value
        } else {
            throw SerializationError.MissingMandatoryKey(key: key)
        }
    }
}
