//
//  Error.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public enum Error: ErrorType, CustomStringConvertible, Unboxable {
    
    init(unboxer: Unboxer) {
        let error: String = unboxer.unbox("error")
        let error_description: String = unboxer.unbox("error_description")
        self = .ServerErrorWithDescrition(error: error, description: error_description)
    }
    
    case NoActiveSession
    case EmptyResponse
    case NetworkLayerError(error: NSError)
    case ServerError(message: String)
    case ServerErrorWithDescrition(error: String, description: String)
    case InternalError(reason: String?)
    case TaskProcessingError(accountID: String, message: String?)
    case TaskProcessingTimeout
    case UnboxingError(String)

    public var description: String {
        get {
            switch self {
            case .NoActiveSession:
                return "No Figo session active. Login with credentials or refresh token."
            case .EmptyResponse:
                return "Server returned empty response"
            case .NetworkLayerError(let error):
                return error.localizedFailureReason ?? error.localizedDescription
            case .ServerError(let message):
                return message
            case .ServerErrorWithDescrition(let error, let description):
                return "Server error: \(error) (\(description))"
            case .InternalError(let reason):
                return reason ?? "No failure reason given"
            case .TaskProcessingError(let accountID, let message):
                return "Server failed to complete task for account \(accountID): \(message ?? "No message")"
            case .TaskProcessingTimeout:
                return "Task processing timeout"
            case .UnboxingError(let description):
                return description
            }
        }
    }
    
}
