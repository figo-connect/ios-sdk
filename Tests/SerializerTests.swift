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

    func testAccountSerializerYieldsObject() {
        let bundle = NSBundle(forClass: self.classForCoder)
        let path = bundle.pathForResource("Account", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        let JSON = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
        let account = try! Account(representation: JSON)
        print(account)
    }
    
    
    func testThatSerializerThrowsCorrectErrorForMissingMandatoryKeys() {
        let bundle = NSBundle(forClass: self.classForCoder)
        let path = bundle.pathForResource("Account", ofType: "json")!
        let data = NSData(contentsOfFile: path)!
        var JSON: [String: AnyObject] = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! [String: AnyObject]
        
        JSON.removeValueForKey("account_id")
        
        do {
            let account = try Account(representation: JSON)
            XCTAssertNil(account)
            XCTFail()
        }
        catch (let error as FigoError) {
            XCTAssert(error.failureReason.containsString("Account"))
            XCTAssert(error.failureReason.containsString("account_id"))
            print(error)
        }
        catch {
            XCTFail()
        }
    }
    
    func testThatSerializerThrowsCorrectErrorForUnexpectedRootObjectType() {
        let JSONObject = ["value1", "value2"]
        
        do {
            let account = try Account(representation: JSONObject)
            XCTAssertNil(account)
            XCTFail()
        }
        catch (let error as FigoError) {
            XCTAssert(error.failureReason.containsString("Account"))
            XCTAssert(error.failureReason.containsString("unexpected root object type"))
            print(error)
        }
        catch {
            XCTFail()
        }
    }
}
