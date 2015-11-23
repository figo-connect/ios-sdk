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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAccountSerializer() {
        let bundle = NSBundle(forClass: self.classForCoder)
        let path = bundle.pathForResource("Account", ofType: "json")!
        if let data = NSData(contentsOfFile: path) {

            if let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) {
                if let account = try? Account(representation: JSON) {
                    print(account)
                }
            }
            
        }
    }
    

    
}
