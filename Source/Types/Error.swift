//
//  Error.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public enum Error: ErrorType, ResponseObjectSerializable, CustomStringConvertible {
    
    public init(representation: AnyObject) throws {
        let mapper = try PropertyMapper(representation, typeName: "\(self.dynamicType)")
        let error: String = try mapper.valueForKeyName("error")
        let error_description: String = try mapper.valueForKeyName("error_description")
        self = .ServerErrorWithDescrition(error: error, description: error_description)
    }
    
    case NoActiveSession
    case JSONMissingMandatoryKey(key: String, typeName: String)
    case JSONMissingMandatoryValue(key: String, typeName: String)
    case JSONUnexpectedValue(key: String, typeName: String)
    case JSONUnexpectedType(key: String, typeName: String)
    case JSONUnexpectedRootObject(typeName: String)
    case NetworkLayerError(error: NSError)
    case ServerError(message: String)
    case ServerErrorWithDescrition(error: String, description: String)
    case UnspecifiedError(reason: String?)
    case TaskProcessingError(accountID: String, message: String?)

    public var failureReason: String {
        get {
            switch self {
            case .NoActiveSession:
                return "No Figo session active. Login with credentials or refresh token."
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
            case .ServerErrorWithDescrition(_, let description):
                return description
            case .UnspecifiedError(let reason):
                return reason ?? "No failure reason given"
            case .TaskProcessingError(let accountID, let message):
                return "Server faild to complete task for account \(accountID): \(message ?? "No message")"
            }
        }
    }
    
    public var description: String {
        get { return failureReason }
    }
}
