//
//  Error.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation



public final class Error: NSError, ResponseObjectSerializable {
    
    let error_description: String
    
    public init(response: NSHTTPURLResponse, representation: AnyObject) throws {
        error_description = representation.valueForKeyPath("error_description") as? String ?? ""
        let userInfo = [NSLocalizedFailureReasonErrorKey: error_description]
        super.init(domain: Domain, code: Code.ServerErrorResponse.rawValue, userInfo: userInfo)
    }
    
    public init(code: Code, failureReason: String) {
        error_description = failureReason
        let userInfo = [NSLocalizedFailureReasonErrorKey: error_description]
        super.init(domain: Domain, code: code.rawValue, userInfo: userInfo)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        error_description = ""
        super.init(coder: aDecoder)
    }
    
    public let Domain = "me.figo.error"
    
    public enum Code: Int {
        case UnrecognizedServerResponse = -4001
        case ServerErrorResponse        = -4002
        case UnexpectedJSONStructure    = -4003
        case MissingJSONKey             = -4004
    }
}


public enum SerializationError: ErrorType {
    case MissingMandatoryKey(key: String)
    case UnexpectedType(key: String)
    case UnexpectedRootObject
}