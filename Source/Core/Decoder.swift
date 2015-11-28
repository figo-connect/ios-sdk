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
            throw FigoError.JSONUnexpectedRootObject(typeName: typeName)
        }
        self.representation = representation
        self.typeName = typeName
    }
    
    func valueForKey<T>(key: PropertyKey) throws -> T {
        return try valueForKeyName(key.rawValue)
    }
    
    func valueForKeyName<T>(keyName: String) throws -> T {
        guard representation[keyName] != nil else {
            throw FigoError.JSONMissingMandatoryKey(key: keyName, typeName: typeName)
        }
        guard (representation[keyName] as? NSNull) == nil else {
            throw FigoError.JSONMissingMandatoryValue(key: keyName, typeName: typeName)
        }
        guard let value = representation[keyName] as? T else {
            throw FigoError.JSONUnexpectedType(key: keyName, typeName: typeName)
        }
        return value
    }
    
    func optionalForKey<T>(key: PropertyKey) throws -> T? {
        return try optionalForKeyName(key.rawValue)
    }
    
    func optionalForKeyName<T>(keyName: String) throws -> T? {
        guard representation[keyName] != nil else {
            return nil
        }
        guard (representation[keyName] as? NSNull) == nil else {
            return nil
        }
        guard let value: T? = representation[keyName] as? T? else {
            throw FigoError.JSONUnexpectedType(key: keyName, typeName: typeName)
        }
        return value
    }
}

func decodeTaskToken(data: NSData?) -> FigoResult<String> {
    do {
        if let data = data {
            if let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject] {
                if let token: String = JSON["task_token"] as? String {
                    return FigoResult.Success(token)
                }
            }
        }
        return FigoResult.Failure(FigoError.JSONMissingMandatoryValue(key: "task_token", typeName: ""))

    } catch (let error as NSError) {
        return FigoResult.Failure(FigoError.JSONSerializationError(error: error))
    }
}

func decodeJSON(data: NSData?) -> ([String: AnyObject]?, FigoError?) {
    guard let data = data else { return (nil, nil) }
    do {
        let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject]
        return (JSON, nil)
    } catch (let error as NSError) {
        return (nil, FigoError.JSONSerializationError(error: error))
    }
}

func decodeObject<T: ResponseObjectSerializable>(data: NSData?) -> (T?, FigoError?) {
    guard let data = data else { return (nil, nil) }
    var JSON: AnyObject
    var decodedObject: T
    do {
        JSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
    } catch (let error as NSError) {
        return (nil, FigoError.JSONSerializationError(error: error))
    }
    do {
        decodedObject = try T(representation: JSON)
        return (decodedObject, nil)
    } catch (let error as FigoError) {
        return (nil, error)
    } catch {
        return (nil, FigoError.UnspecifiedError(reason: "Failed to serialize type: \(T.self)"))
    }
}

func decodeCollection<T: ResponseCollectionSerializable>(data: NSData?) -> ([T]?, FigoError?) {
    guard let data = data else { return (nil, nil) }
    do {
        let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
        if let decodedCollection = try? T.collection(JSON) {
            return (decodedCollection, nil)
        }
    } catch (let error as NSError) {
        return (nil, FigoError.JSONSerializationError(error: error))
    }
    return (nil, nil)
}

func base64Encode(clientID: String, _ clientSecret: String) -> String {
    let clientCode: String = clientID + ":" + clientSecret
    let utf8str: NSData = clientCode.dataUsingEncoding(NSUTF8StringEncoding)!
    return utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn)
}
