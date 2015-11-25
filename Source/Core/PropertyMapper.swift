//
//  PropertyMapper.swift
//  Figo
//
//  Created by Christian König on 24.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


struct PropertyMapper {
    let representation: Dictionary<String, AnyObject>
    let typeName: String
    
    init(_ representation: AnyObject, typeName: String) throws {
        guard let representation: Dictionary<String, AnyObject> = representation as? Dictionary<String, AnyObject> else {
            throw Error.JSONUnexpectedRootObject(typeName: typeName)
        }
        self.representation = representation
        self.typeName = typeName
    }
    
    func valueForKey<T>(key: PropertyKey) throws -> T {
        return try valueForKeyName(key.rawValue)
    }
    
    func valueForKeyName<T>(keyName: String) throws -> T {
        guard representation[keyName] != nil else {
            throw Error.JSONMissingMandatoryKey(key: keyName, typeName: typeName)
        }
        guard (representation[keyName] as? NSNull) == nil else {
            throw Error.JSONMissingMandatoryValue(key: keyName, typeName: typeName)
        }
        guard let value = representation[keyName] as? T else {
            throw Error.JSONUnexpectedType(key: keyName, typeName: typeName)
        }
        return value
    }
    
    func optionalValueForKey<T>(key: PropertyKey) throws -> T? {
        return try optionalValueForKeyName(key.rawValue)
    }

    func optionalValueForKeyName<T>(keyName: String) throws -> T? {
        guard representation[keyName] != nil else {
            return nil
        }
        guard (representation[keyName] as? NSNull) == nil else {
            return nil
        }
        guard let value: T? = representation[keyName] as? T? else {
            throw Error.JSONUnexpectedType(key: keyName, typeName: typeName)
        }
        return value
    }
}

