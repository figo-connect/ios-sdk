//
//  BaseType.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


// MARK: Public

public protocol JSONObjectConvertible {
    var JSONObject: [String: AnyObject] { get }
}

// MARK: Internal

protocol ResponseObjectSerializable {
    init(representation: AnyObject) throws
}

protocol ResponseCollectionSerializable {
    static func collection(representation: AnyObject) throws -> [Self]
}

protocol PropertyKey {
    var rawValue: String { get }
}

func JSONStringFromType(type: JSONObjectConvertible) -> String {
    if let data = try? NSJSONSerialization.dataWithJSONObject(type.JSONObject, options: NSJSONWritingOptions.PrettyPrinted) {
        if let string = String(data: data, encoding: NSUTF8StringEncoding) {
            return string
        }
    }
    return ""
}
