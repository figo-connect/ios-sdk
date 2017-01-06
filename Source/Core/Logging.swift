//
//  Logging.swift
//  Figo
//
//  Created by Christian König on 24.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import XCGLogger


// Internal logger instance
internal var log = XCGLogger.default


func debugPrintRequest(_ request: URLRequest) {
    log.debug("⬆️ \(request.httpMethod!) \(request.url!)")
    if let fields = request.allHTTPHeaderFields {
        for (key, value) in fields {
            log.verbose("\(key): \(value)")
        }
    }
    if let data = request.httpBody {
        let string = String(data: data, encoding: String.Encoding.utf8)
        log.verbose(string)
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
        if let string = String(data: data, encoding: String.Encoding.utf8) {
            log.verbose(string)
        }
    }
}
