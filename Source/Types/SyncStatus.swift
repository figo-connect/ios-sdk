//
//  SyncStatus.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct SyncStatus {
    
    public let code: Int
    public let message: String?
    public let success_timestamp: String
    public let sync_timestamp: String
}

extension SyncStatus: ResponseObjectSerializable {
    
    init(representation: AnyObject) throws {
        let mapper = try Decoder(representation, typeName: "\(self.dynamicType)")
        
        code = try mapper.valueForKeyName("code")
        message = try mapper.optionalForKeyName("message")
        success_timestamp = try mapper.valueForKeyName("success_timestamp")
        sync_timestamp = try mapper.valueForKeyName("sync_timestamp")
    }
}

extension SyncStatus: ResponseOptionalObjectSerializable {
    init?(optionalRepresentation: AnyObject?) throws {
        guard let representation = optionalRepresentation else {
            return nil
        }
        try self.init(representation: representation)
    }
}