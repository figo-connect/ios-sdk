//
//  Logging.swift
//  Figo
//
//  Created by Christian König on 24.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


// Internal logger instance
internal var log = XCGLogger.defaultInstance()


func debugPrintRequest(request: NSURLRequest) {
    log.debug("⬆️ \(request.HTTPMethod!) \(request.URL!)")
    if let fields = request.allHTTPHeaderFields {
        for (key, value) in fields {
            log.verbose("\(key): \(value)")
        }
    }
    if let data = request.HTTPBody {
        let string = String(data: data, encoding: NSUTF8StringEncoding)
        log.verbose(string)
    }
}


func debugPrintResponse(data: NSData?, _ response: NSHTTPURLResponse?, _ error: NSError?) {
    if let response = response {
        log.debug("⬇️ \(response.statusCode)")
    }
    if let error = error {
        log.error(error.localizedDescription)
    }
    if let data = data {
        if let string = String(data: data, encoding: NSUTF8StringEncoding) {
            log.verbose(string)
        }
    }
}