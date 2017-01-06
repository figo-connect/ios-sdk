//
//  Result.swift
//  Figo
//
//  Created by Christian König on 28.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public enum Result<Value>: CustomStringConvertible, CustomDebugStringConvertible {
    
    case success(Value)
    case failure(FigoError)
    
    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: FigoError? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }

    public var description: String {
        switch self {
        case .success:
            return "SUCCESS"
        case .failure:
            return "FAILURE"
        }
    }

    public var debugDescription: String {
        switch self {
        case .success(let value):
            return "SUCCESS: \(value)"
        case .failure(let error):
            return "FAILURE: \(error)"
        }
    }
}

