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
    public let successDate: Date
    public let syncDate: Date
    
    
    init(unboxer: Unboxer) {
        code          = unboxer.unbox("code")
        message       = unboxer.unbox("message")
        successDate   = unboxer.unbox("success_timestamp")
        syncDate      = unboxer.unbox("sync_timestamp")
    }
}
