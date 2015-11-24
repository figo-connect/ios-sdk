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
            throw FigoError.JSONUnexpectedRootObject(object: objectType)
        }
        self.representation = representation
        self.objectType = objectType
    }
    
    func stringForKey(key: String) throws -> String {
        if let value = representation[key] as? String {
            return value
        } else {
            throw FigoError.JSONMissingMandatoryKey(key: key, object: objectType)
        }
    }
}
