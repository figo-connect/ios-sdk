//
//  SyncStatus.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public struct SyncStatus: ResponseObjectSerializable, ResponseOptionalObjectSerializable {
    
    let code: Int
    let message: String
    let success_timestamp: String
    let sync_timestamp: String
    
    private enum Key: String, PropertyKey {
        case code, message, success_timestamp, sync_timestamp
    }
    
    public init(representation: AnyObject) throws {
        let mapper = try Decoder(representation, typeName: "\(self.dynamicType)")
        
        code = try mapper.valueForKey(Key.code)
        message = try mapper.valueForKey(Key.message)
        success_timestamp = try mapper.valueForKey(Key.success_timestamp)
        sync_timestamp = try mapper.valueForKey(Key.sync_timestamp)
    }
    
    public init?(optionalRepresentation: AnyObject?) throws {
        guard let representation = optionalRepresentation else {
            return nil
        }
        try self.init(representation: representation)
    }
}