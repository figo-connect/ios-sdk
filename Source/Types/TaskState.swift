//
//  TaskState.swift
//  Figo
//
//  Created by Christian König on 26.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


internal struct TaskState: Unboxable {
    
    /// Account ID of currently processed account
    let account_id: String

    /// Status message or error message for currently processed account
    let message: String
    
    /// If this flag is set, then the figo Connect server waits for a PIN
    let is_waiting_for_pin: Bool

    /// If this flag is set, then the figo Connect server waits for a response to the parameter challenge
    let is_waiting_for_response: Bool
    
    /// If this flag is set, then an error occurred and the figo Connect server waits for a continuation
    let is_erroneous: Bool
    
    /// If this flag is set, then the communication with the bank server has been completed
    let is_ended: Bool
    
    /// Challenge object
    let challenge: Challenge?
    
    
    init(unboxer: Unboxer) {
        account_id              = unboxer.unbox("account_id")
        message                 = unboxer.unbox("message")
        is_waiting_for_pin      = unboxer.unbox("is_waiting_for_pin")
        is_waiting_for_response = unboxer.unbox("is_waiting_for_response")
        is_erroneous            = unboxer.unbox("is_erroneous")
        is_ended                = unboxer.unbox("is_ended")
        challenge               = unboxer.unbox("challenge")
    }
}


internal struct PollTaskStateParameters: JSONObjectConvertible {
    
    /// Task token
    let id: String
    
    /// Submit PIN. If this parameter is set, then the parameter save_pin must be set, too. (optional)
    let pin: String?
    
    /// This flag signals to continue after an error condition or to skip a PIN or challenge-response entry (optional)
    let continueAfterError: Bool?
    
    /// This flag indicates whether the user has chosen to save the PIN on the figo Connect server (optional)
    let savePin: Bool?
    
    /// Submit response to challenge. (optional)
    let response: String?
    
    
    var JSONObject: [String: AnyObject] {
        var dict = Dictionary<String, AnyObject>()
        dict["id"] = id
        dict["pin"] = pin
        dict["continue"] = continueAfterError
        dict["save_pin"] = savePin
        dict["response"] = response
        return dict    
    }
}

