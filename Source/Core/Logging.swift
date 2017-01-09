//
//  Logging.swift
//  Figo
//
//  Created by Christian König on 24.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
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
    public var debug: (String) -> Void = { message in
        
    }
    public var verbose: (String) -> Void = { message in
        
    }
    public var error: (String) -> Void = { message in
        
    }
}

public struct ConsoleLogger: Logger {
    public init() {
    
    }
    public var debug: (String) -> Void = { message in
        print(message)
    }
    public var verbose: (String) -> Void = { message in
        print(message)
    }
    public var error: (String) -> Void = { message in
        print(message)
    }
}


func debugPrintRequest(_ request: URLRequest) {
    log.debug("⬆️ \(request.httpMethod!) \(request.url!)")
    if let fields = request.allHTTPHeaderFields {
        for (key, value) in fields {
            log.verbose("\(key): \(value)")
        }
    }
    if let data = request.httpBody {
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            log.verbose(string)
        }
    }
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
