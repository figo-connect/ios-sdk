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
    
    let representation: Dictionary<String, AnyObject>
    let objectType: String
    
    init(representation: AnyObject, objectType: String) throws {
        guard let representation: Dictionary<String, AnyObject> = representation as? Dictionary<String, AnyObject> else {
            throw Error.JSONUnexpectedRootObject(object: objectType)
        }
        self.representation = representation
        self.objectType = objectType
    }
    
    func stringForKey(key: String) throws -> String {
        guard let anyValue = representation[key] else {
            throw Error.JSONMissingMandatoryKey(key: key, object: objectType)
        }
        
        guard let value = anyValue as? String else {
            throw Error.JSONUnexpectedType(key: key, object: objectType)
        }

        return value
    }
}
