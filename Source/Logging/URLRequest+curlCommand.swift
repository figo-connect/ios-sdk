//
//  URLRequest+curlCommand.swift
//  Figo
//
//  Created by Christian König on 29.01.17.
//  Copyright © 2017 figo GmbH. All rights reserved.
//

import Foundation


extension URLRequest {
    
    var curlCommand: String {
        var command = "curl -k"
        if let method = self.httpMethod {
            if method == "PUT" || method == "DELETE" {
                command.append(" -X \(method)")
            }
            if method == "POST" || method == "PUT" || method == "DELETE" {
                if let httpBody = self.httpBody {
                    var body = String(data: httpBody, encoding: .utf8)
                    body = body?.replacingOccurrences(of: "\"", with: "\\\"")
                    if let body = body {
                        command.append(" -d \"\(body)\"")
                    }
                }
            }
        }
        self.allHTTPHeaderFields?.forEach { (key: String, value: String) in
            command.append(" -H \"\(key): \(value)\"")
        }
        command.append(" --compressed")
        command.append(" \"\(self.url!.absoluteString)\"")
        command.append(" | python -mjson.tool")
        return command
    }
}
