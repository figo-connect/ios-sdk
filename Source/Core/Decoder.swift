//
//  Decoder.swift
//  Figo
//
//  Created by Christian König on 27.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


struct Decoder {
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

func decodeObject<T: ResponseObjectSerializable>(data: NSData?) -> (T?, Error?) {
    guard let data = data else { return (nil, nil) }
    do {
        let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
        if let decodedObject = try? T(representation: JSON) {
            return (decodedObject, nil)
        }
    } catch (let error as NSError) {
        return (nil, Error.JSONSerializationError(error: error))
    }
    return (nil, nil)
}

func decodeCollection<T: ResponseCollectionSerializable>(data: NSData?) -> ([T]?, Error?) {
    guard let data = data else { return (nil, nil) }
    do {
        let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
        if let decodedCollection = try? T.collection(JSON) {
            return (decodedCollection, nil)
        }
    } catch (let error as NSError) {
        return (nil, Error.JSONSerializationError(error: error))
    }
    return (nil, nil)
}

func base64Encode(clientID: String, _ clientSecret: String) -> String {
    let clientCode: String = clientID + ":" + clientSecret
    let utf8str: NSData = clientCode.dataUsingEncoding(NSUTF8StringEncoding)!
    return utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn)
}
