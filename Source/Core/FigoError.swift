//
//  FigoError.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public enum FigoError: ErrorType, CustomStringConvertible, Unboxable {
    
    init(unboxer: Unboxer) {
        let error: String = unboxer.unbox("error")
        let error_description: String = unboxer.unbox("error_description")
        self = .ServerErrorWithDescrition(error: error, description: error_description)
    }
    
    case NoActiveSession
    case EmptyResponse
    case JSONMissingMandatoryKey(key: String, typeName: String)
    case JSONMissingMandatoryValue(key: String, typeName: String)
    case JSONUnexpectedValue(key: String, typeName: String)
    case JSONUnexpectedType(key: String, typeName: String)
    case JSONUnexpectedRootObject(typeName: String)
    case JSONSerializationError(error: NSError)
    case NetworkLayerError(error: NSError)
    case ServerError(message: String)
    case ServerErrorWithDescrition(error: String, description: String)
    case UnspecifiedError(reason: String?)
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
            case .JSONMissingMandatoryKey(let key, let typeName):
                return "Failed to create object '\(typeName)' from JSON because of missing mandatory key: \(key)"
            case .JSONMissingMandatoryValue(let key, let typeName):
                return "Failed to create object '\(typeName)' from JSON because of missing mandatory value for key: \(key)"
            case .JSONUnexpectedValue(let key, let typeName):
                return "Failed to create object '\(typeName)' from JSON because of unexpected value for key: \(key)"
            case .JSONUnexpectedType(let key, let typeName):
                return "Failed to create object '\(typeName)' from JSON because of unexpected value type for key: \(key)"
            case .JSONUnexpectedRootObject(let typeName):
                return "Failed to create object '\(typeName)' from JSON because of unexpected root object type"
            case .NetworkLayerError(let error):
                return error.localizedFailureReason ?? error.localizedDescription
            case .ServerError(let message):
                return message
            case .ServerErrorWithDescrition(let error, let description):
                return "Server error: \(error) (\(description))"
            case .UnspecifiedError(let reason):
                return reason ?? "No failure reason given"
            case .TaskProcessingError(let accountID, let message):
                return "Server failed to complete task for account \(accountID): \(message ?? "No message")"
            case .JSONSerializationError(let error):
                return "Failed to serialize JSON (\(error.localizedDescription))"
            case .TaskProcessingTimeout:
                return "Task processing timeout"
            case .UnboxingError(let description):
                return description
            }
        }
    }
    
}
