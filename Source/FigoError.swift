//
//  FigoError.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public struct FigoError: Error, CustomStringConvertible, Unboxable {
    
    public let code: Int
    public let group: String?
    public let message: String?
    public let name: String?
    public let originalDescription: String?
    public let data: [String:Any]?
    
    public init(unboxer: Unboxer) throws {
        code                = (try? unboxer.unbox(key: "code")) ?? 0
        group               = unboxer.unbox(key: "group")
        message             = unboxer.unbox(key: "message")
        name                = unboxer.unbox(key: "name")
        originalDescription = unboxer.unbox(key: "description")
        data                = unboxer.unbox(key: "data")
    }
    
    internal init(error: InternalError) {
        code = error.code
        group = nil
        message = nil
        name = nil
        originalDescription = error.description
        data = nil
    }
    
    public var description: String {
        get {
            if let description = originalDescription {
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


public enum InternalError: Error, CustomStringConvertible {
    
    case noActiveSession
    case emptyResponse
    case networkLayerError(error: Error)
    case serverError(message: String)
    case internalError(reason: String?)
    case taskProcessingError(accountID: String, message: String?)
    case taskProcessingTimeout
    case unboxingError(String)
    
    public var code: Int {
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
    
    public var description: String {
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
