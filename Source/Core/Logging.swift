//
//  Logging.swift
//  Figo
//
//  Created by Christian König on 24.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public var FigoLoggingEnabled = true


func debugPrintRequest(request: NSURLRequest) {
    guard FigoLoggingEnabled else { return }
    
    debugPrint("⬆️ \(request.HTTPMethod!) \(request.URL!)")
    if let fields = request.allHTTPHeaderFields {
        for (key, value) in fields {
            debugPrint(key + ": " + value)
        }
    }
    if let data = request.HTTPBody {
        if let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) {
            debugPrint(JSON)
        }
    }
}


func debugPrintResponse(data: NSData?, _ response: NSHTTPURLResponse?, _ error: NSError?) {
    guard FigoLoggingEnabled else { return }
    
    if let response = response {
        debugPrint("⬇️ \(response.statusCode)")
    }
    if let error = error {
        debugPrint(error.localizedDescription)
    }
    if let data = data {
        if let string = String(data: data, encoding: NSUTF8StringEncoding) {
            if let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) {
                debugPrint(JSON)
            } else {
                debugPrint(string)
            }
        }
    }
}