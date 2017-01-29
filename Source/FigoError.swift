//
//  FigoError.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


/**
 If an error occurs, the API returns an error object with a couple of fields providing further details.
 */
public struct FigoError: Error, CustomStringConvertible, Unboxable {
    
    /// Error code (see http://docs.figo.io/#error-handling)
    public let code: Int
    
    // String identifying the source of the error
    public let group: String?
    
    /// Error message
    public let message: String?
    
    /// Error name
    public let name: String?
    
    /// Error description (Renamed to allow a non-optinal implementation of CustomStringConvertible)
    public let narrative: String?
    
    /// Any additional data
    public let data: [String:Any]?
    
    
    init(unboxer: Unboxer) throws {
        code                = (try? unboxer.unbox(key: "code")) ?? 0
        group               = unboxer.unbox(key: "group")
        message             = unboxer.unbox(key: "message")
        name                = unboxer.unbox(key: "name")
        narrative           = unboxer.unbox(key: "description")
        data                = unboxer.unbox(key: "data")
    }
    
    init(error: InternalError) {
        code = error.code
        group = nil
        message = nil
        name = nil
        narrative = error.description
        data = nil
    }
    
    /// Narrative, message, name or code (depending on what values are available)
    public var description: String {
        get {
            if let description = narrative {
                return description
            }
            if let description = message {
                return description
            }
            if let description = name {
                return description
            }
            return "\(code)"
        }
    }
    
}


/**
 Internal error type which is transformed into an FigoError
 */
internal enum InternalError: Error, CustomStringConvertible {
    
    case noActiveSession
    case emptyResponse
    case networkLayerError(error: Error)
    case serverError(message: String)
    case internalError(reason: String?)
    case taskProcessingError(accountID: String, message: String?)
    case taskProcessingTimeout
    case unboxingError(String)
    
    var code: Int {
        get {
            switch self {
            case .noActiveSession:
                return 500901
            case .emptyResponse:
                return 500902
            case .networkLayerError:
                return 500903
            case .serverError:
                return 500904
            case .internalError:
                return 500905
            case .taskProcessingError:
                return 500906
            case .taskProcessingTimeout:
                return 500906
            case .unboxingError:
                return 500907
            }
        }
    }
    
    var description: String {
        get {
            switch self {
            case .noActiveSession:
                return "No Figo session active. Login with credentials or refresh token."
            case .emptyResponse:
                return "Server returned empty response"
            case .networkLayerError(let error):
                return error.localizedDescription
            case .serverError(let message):
                return message
            case .internalError(let reason):
                return reason ?? "No failure reason given"
            case .taskProcessingError(let accountID, let message):
                return "Server failed to complete task for account \(accountID): \(message ?? "No message")"
            case .taskProcessingTimeout:
                return "Task processing timeout"
            case .unboxingError(let description):
                return description
            }
        }
    }
}
