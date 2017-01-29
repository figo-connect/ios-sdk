//
//  Logging.swift
//  Figo
//
//  Created by Christian König on 24.11.15.
//  Copyright © 2015 figo GmbH. All rights reserved.
//

import Foundation


// Internal logger instance
internal var log: Logger = VoidLogger()


public protocol Logger {
    var debug: (String) -> Void { get }
    var verbose: (String) -> Void { get }
    var error: (String) -> Void { get }
}

public struct VoidLogger: Logger {
    public var debug: (String) -> Void = { _ in }
    public var verbose: (String) -> Void = { _ in }
    public var error: (String) -> Void = { _ in }
}

/**
 Simple implementation of a console logger
 
 Does not log verbosely per default.
 */
public struct ConsoleLogger: Logger {
    
    public enum LogLevel {
        case verbose
        case debug
        case error
    }
    
    public let verbose: (String) -> Void
    public let debug: (String) -> Void
    public let error: (String) -> Void
    
    public init(levels: [LogLevel]? = [.debug, .error]) {
        if levels?.contains(.debug) ?? false {
            self.debug = { message in
                print(message)
            }
        } else {
            self.debug = { _ in
                
            }
        }
        
        if levels?.contains(.verbose) ?? false {
            self.verbose = { message in
                print(message)
            }
        } else {
            self.verbose = { _ in
                
            }
        }
        
        if levels?.contains(.error) ?? false {
            self.error = { message in
                print(message)
            }
        } else {
            self.error = { _ in
                
            }
        }
    }
}

func debugPrintRequest(_ request: URLRequest) {
    log.debug("⬆️ \(request.httpMethod!) \(request.url!)")
    log.verbose(request.curlCommand)
}


func debugPrintResponse(_ data: Data?, _ response: HTTPURLResponse?, _ error: Error?) {
    if let response = response {
        log.debug("⬇️ \(response.statusCode)")
    }
    if let error = error {
        log.error(error.localizedDescription)
    }
    if let data = data {
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
            if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]) {
                if let string = String(data: jsonData, encoding: String.Encoding.utf8) {
                    log.verbose(string)
                }
            }
        }
    }
}
