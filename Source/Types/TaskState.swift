//
//  TaskState.swift
//  Figo
//
//  Created by Christian König on 26.11.15.
//  Copyright © 2015 figo GmbH. All rights reserved.
//


internal struct TaskTokenEvelope: Unboxable {
 
    let taskToken: String
    
    init(unboxer: Unboxer) throws {
        taskToken = try unboxer.unbox(key: "task_token")
    }
}


internal struct TaskState: Unboxable {
    
    /// Account ID of currently processed account
    let accountID: String

    /// Status message or error message for currently processed account
    let message: String
    
    /// If this flag is set, then the figo Connect server waits for a PIN
    let isWaitingForPIN: Bool

    /// If this flag is set, then the figo Connect server waits for a response to the parameter challenge
    let isWaitingForResponse: Bool
    
    /// If this flag is set, then an error occurred and the figo Connect server waits for a continuation
    let isErroneous: Bool
    
    /// If this flag is set, then the communication with the bank server has been completed
    let isEnded: Bool
    
    /// Challenge object
    let challenge: Challenge?
    
    let error: FigoError?
    
    
    init(unboxer: Unboxer) throws {
        accountID               = try unboxer.unbox(key: "account_id")
        message                 = try unboxer.unbox(key: "message")
        isWaitingForPIN         = try unboxer.unbox(key: "is_waiting_for_pin")
        isWaitingForResponse    = try unboxer.unbox(key: "is_waiting_for_response")
        isErroneous             = try unboxer.unbox(key: "is_erroneous")
        isEnded                 = try unboxer.unbox(key: "is_ended")
        challenge               = unboxer.unbox(key: "challenge")
        error                   = unboxer.unbox(key: "error")
    }
}




