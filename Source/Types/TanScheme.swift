//
//  TanScheme.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public struct TanScheme: JSONObjectConvertible, ResponseObjectSerializable, ResponseCollectionSerializable {
    
    let medium_name: String
    let name: String
    let tan_scheme_id: String
    
    private enum Key: String, PropertyKey {
        case medium_name
        case name
        case tan_scheme_id
    }
    
    public init(representation: AnyObject) throws {
        let mapper = try PropertyMapper(representation, typeName: "\(self.dynamicType)")
        medium_name = try mapper.valueForKey(Key.medium_name)
        name = try mapper.valueForKey(Key.name)
        tan_scheme_id = try mapper.valueForKey(Key.tan_scheme_id)
    }
    
    public static func collection(representation: AnyObject) throws -> [TanScheme] {
        guard let representation: [[String: AnyObject]] = representation as? [[String: AnyObject]] else {
            throw Error.JSONUnexpectedType(key: "supported_tan_schemes", typeName: "Account")
        }
        var schemes = [TanScheme]()
        for value in representation {
            let scheme = try TanScheme(representation: value)
            schemes.append(scheme)
        }
        return schemes
    }
    
    public var JSONObject: [String: AnyObject] {
        get {
            var dict = Dictionary<String, AnyObject>()
            dict[Key.medium_name.rawValue] = medium_name
            dict[Key.name.rawValue] = name
            dict[Key.tan_scheme_id.rawValue] = tan_scheme_id
            return dict
        }
    }
    
    public var description: String {
        get {
            return JSONStringFromType(self)
        }
    }
}