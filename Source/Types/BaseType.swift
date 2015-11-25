//
//  BaseType.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public protocol ResponseObjectSerializable {
    init(response: NSHTTPURLResponse, representation: AnyObject) throws
}

public protocol ResponseCollectionSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) throws -> [Self]
}
