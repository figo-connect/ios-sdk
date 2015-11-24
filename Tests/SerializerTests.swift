//
//  SerializerTests.swift
//  Figo
//
//  Created by Christian König on 23.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
@testable import Figo


class SerializerTests: XCTestCase {

    func testAccountSerializer() {
        let bundle = NSBundle(forClass: self.classForCoder)
        let path = bundle.pathForResource("Account", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let JSON = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        let account = try! Account(representation: JSON)
        print(account)
    }
    
}
