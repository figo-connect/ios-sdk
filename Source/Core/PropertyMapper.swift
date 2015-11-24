//
//  PropertyMapper.swift
//  Figo
//
//  Created by Christian König on 24.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public protocol JSONObjectConvertible {
    var JSONObject: [String: AnyObject] { get }
}

func JSONStringFromType(type: JSONObjectConvertible) -> String {
    if let data = try? NSJSONSerialization.dataWithJSONObject(type.JSONObject, options: NSJSONWritingOptions.PrettyPrinted) {
        if let string = String(data: data, encoding: NSUTF8StringEncoding) {
            return string
        }
    }
    return ""
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
    
    func valueForKey<T>(key: String) throws -> T {
        guard let anyValue = representation[key] else {
            throw Error.JSONMissingMandatoryKey(key: key, object: objectType)
        }
        guard let value = anyValue as? T else {
            throw Error.JSONUnexpectedType(key: key, object: objectType)
        }
        return value
    }
}
