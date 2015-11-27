//
//  SyncStatus.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public struct SyncStatus: JSONObjectConvertible, ResponseObjectSerializable {
    
    let code: Int
    let message: String
    let success_timestamp: String
    let sync_timestamp: String
    
    private enum Key: String, PropertyKey {
        case code
        case message
        case success_timestamp
        case sync_timestamp
    }
    
    public init(representation: AnyObject) throws {
        let mapper = try Decoder(representation, typeName: "\(self.dynamicType)")
        
        code = try mapper.valueForKey(Key.code)
        message = try mapper.valueForKey(Key.message)
        success_timestamp = try mapper.valueForKey(Key.success_timestamp)
        sync_timestamp = try mapper.valueForKey(Key.sync_timestamp)
    }
    
    public var JSONObject: [String: AnyObject] {
        get {
            var dict = Dictionary<String, AnyObject>()
            dict[Key.code.rawValue] = code
            dict[Key.message.rawValue] = message
            dict[Key.success_timestamp.rawValue] = success_timestamp
            dict[Key.sync_timestamp.rawValue] = sync_timestamp
            return dict
        }
    }
    
    public var description: String {
        get {
            return JSONStringFromType(self)
        }
    }
}