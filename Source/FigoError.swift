//
//  FigoError.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public enum FigoError: Error, CustomStringConvertible, Unboxable {
    
    public init(unboxer: Unboxer) throws {
        let error: String = try unboxer.unbox(key: "error")
        let error_description: String = try unboxer.unbox(key: "error_description")
        self = .serverErrorWithDescrition(error: error, description: error_description)
    }
    
    case noActiveSession
    case emptyResponse
    case networkLayerError(error: Error)
    case serverError(message: String)
    case serverErrorWithDescrition(error: String, description: String)
    case internalError(reason: String?)
    case taskProcessingError(accountID: String, message: String?)
    case taskProcessingTimeout
    case unboxingError(String)

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
            case .serverErrorWithDescrition(let error, let description):
                return "Server error: \(error) (\(description))"
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
