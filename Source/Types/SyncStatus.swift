//
//  SyncStatus.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct SyncStatus: Unboxable {
    
    public let code: Int
    public let message: String?
    public let success_timestamp: String
    public let sync_timestamp: String
    
    
    init(unboxer: Unboxer) {
        code                = unboxer.unbox("code")
        message             = unboxer.unbox("message")
        success_timestamp   = unboxer.unbox("success_timestamp")
        sync_timestamp      = unboxer.unbox("sync_timestamp")
    }
}
