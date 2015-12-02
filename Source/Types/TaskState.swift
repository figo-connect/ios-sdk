//
//  TaskState.swift
//  Figo
//
//  Created by Christian König on 26.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


internal struct TaskTokenEvelope: Unboxable {
 
    let taskToken: String
    
    init(unboxer: Unboxer) {
        taskToken = unboxer.unbox("task_token")
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
    
    
    init(unboxer: Unboxer) {
        accountID              = unboxer.unbox("account_id")
        message                 = unboxer.unbox("message")
        isWaitingForPIN         = unboxer.unbox("is_waiting_for_pin")
        isWaitingForResponse    = unboxer.unbox("is_waiting_for_response")
        isErroneous             = unboxer.unbox("is_erroneous")
        isEnded                 = unboxer.unbox("is_ended")
        challenge               = unboxer.unbox("challenge")
    }
}




