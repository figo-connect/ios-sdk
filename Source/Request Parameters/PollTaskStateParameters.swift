//
//  PollTaskStateParameters.swift
//  Figo
//
//  Created by Christian König on 01.12.15.
//  Copyright © 2015 figo GmbH. All rights reserved.
//


/**
 Defines the parameters for task state polling

*/
internal struct PollTaskStateParameters: JSONObjectConvertible {
    
    /// Task token
    let taskToken: String
    
    /// Submit PIN. If this parameter is set, then the parameter save_pin must be set, too. (optional)
    let pin: String?
    
    /// This flag signals to continue after an error condition or to skip a PIN or challenge-response entry (optional)
    let continueAfterError: Bool?
    
    /// This flag indicates whether the user has chosen to save the PIN on the figo Connect server (optional)
    let savePin: Bool?
    
    /// Submit response to challenge. (optional)
    let response: String?
    
    
    init(taskToken: String, pin: String? = nil, savePin: Bool? = nil, continueAfterError: Bool? = nil, response: String? = nil) {
        self.taskToken = taskToken
        self.pin = pin
        self.savePin = savePin
        self.continueAfterError = continueAfterError
        self.response = response
    }
    
    var JSONObject: [String: AnyObject] {
        var dict = Dictionary<String, AnyObject>()
        dict["id"] = taskToken as AnyObject?
        dict["pin"] = pin as AnyObject?
        dict["continue"] = continueAfterError as AnyObject?
        if let savePin = savePin {
            dict["save_pin"] = savePin ? "1" as AnyObject : "0" as AnyObject
        }
        dict["response"] = response as AnyObject?
        return dict
    }
}
