//
//  Error.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public enum Error: ErrorType, ResponseObjectSerializable, CustomStringConvertible {
    
    public init(response: NSHTTPURLResponse, representation: AnyObject) throws {
        let mapper = try PropertyMapper(representation: representation, objectType: "\(self.dynamicType)")
        let error = try mapper.stringForKey("error")
        let error_description = try mapper.stringForKey("error_description")
        self = .ServerErrorWithDescrition(error: error, description: error_description)
    }
    
    case NoLogin
    case NoSession
    case JSONMissingMandatoryKey(key: String, object: String)
    case JSONUnexpectedType(key: String, object: String)
    case JSONUnexpectedRootObject(object: String)
    case NetworkLayerError(error: NSError)
    case ServerError(message: String)
    case ServerErrorWithDescrition(error: String, description: String)
    case UnspecifiedError

    public var failureReason: String {
        get {
            switch self {
            case .NoLogin, .NoSession:
                return "No Figo session active. Login with credentials or refresh token."
            case .JSONMissingMandatoryKey(let key, let object):
                return "Failed to created object '\(object)' from JSON because of missing key: \(key)"
            case .JSONUnexpectedType(let key, let object):
                return "Failed to created object '\(object)' from JSON because of unexpected value type for key: \(key)"
            case .JSONUnexpectedRootObject(let object):
                return "Failed to created object '\(object)' from JSON because of unexpected root object type"
            case .NetworkLayerError(let error):
                return error.localizedFailureReason ?? error.localizedDescription
            case .ServerError(let message):
                return message
            case .ServerErrorWithDescrition(_, let description):
                return description
            case .UnspecifiedError:
                return "Unspecified error"
            }
        }
    }
    
    public var description: String {
        get { return failureReason }
    }
}
