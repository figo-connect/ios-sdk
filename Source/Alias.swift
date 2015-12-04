//
//  Aliases.swift
//  Figo
//
//  Created by Christian König on 03.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


/**
A closure which is used for API calls that return nothing
*/
public typealias VoidCompletionHandler = (Result<Void>) -> Void

/**
 A closure which is called periodically during task state polling with a status message from the server
 
 - Parameter message: Status message or error message for currently processed account
 */
public typealias ProgressUpdate = (message: String) -> Void

/**
 A closure which is called when the server needs a PIN from the user to continue
 
 - Parameter message: Status message or error message for currently processed account
 - Parameter accountID: Account ID of currently processed account
 */
public typealias PinResponder = (message: String, accountID: String) -> (pin: String, savePin: Bool)

/**
 A closure which is called when the server needs a response to a challenge from the user
 
 - Parameter message: Status message or error message for currently processed account
 - Parameter accountID: Account ID of currently processed account
 - Parameter challenge: Challenge object
 */
public typealias ChallengeResponder = (message: String, accountID: String, challenge: Challenge) -> String

