//
//  TanScheme.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public struct TanScheme: JSONObjectConvertible, ResponseObjectSerializable {
    
    let medium_name: String
    let name: String
    let tan_scheme_id: String
    
    private enum Key: String {
        case medium_name
        case name
        case tan_scheme_id
    }
    
    public init(response: NSHTTPURLResponse, representation: AnyObject) throws {
        try self.init(representation: representation)
    }
    
    public init(representation: AnyObject) throws {
        let mapper = try PropertyMapper(representation: representation, objectType: "\(self.dynamicType)")
        medium_name = try mapper.valueForKey(Key.medium_name.rawValue)
        name = try mapper.valueForKey(Key.name.rawValue)
        tan_scheme_id = try mapper.valueForKey(Key.tan_scheme_id.rawValue)
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