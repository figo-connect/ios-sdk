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

    func testThatAccountSerializerYieldsObject() {
        let JSONObject = Resources.Account.JSONObject
        let account = try! Account(representation: JSONObject)
        print(account)
    }
    
    
    func testThatSerializerThrowsCorrectErrorForMissingMandatoryKeys() {
        var JSONJSONObject = Resources.Account.JSONObject
        JSONJSONObject.removeValueForKey("account_id")
        
        do {
            let account = try Account(representation: JSONJSONObject)
            XCTAssertNil(account)
            XCTFail()
        }
        catch (let error as Error) {
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
        catch (let error as Error) {
            XCTAssert(error.failureReason.containsString("Account"))
            XCTAssert(error.failureReason.containsString("unexpected root object type"))
            print(error)
        }
        catch {
            XCTFail()
        }
    }
    
    func testThatSerializerThrowsCorrectErrorForUnexpectedValueType() {
        let JSONObject = ["account_id": "A1.1", "account_number": ["1", "2", "3"]]
        
        do {
            let account = try Account(representation: JSONObject)
            XCTAssertNil(account)
            XCTFail()
        }
        catch (let error as Error) {
            XCTAssert(error.failureReason.containsString("Account"))
            XCTAssert(error.failureReason.containsString("account_number"))
            XCTAssert(error.failureReason.containsString("unexpected value type"))
            print(error)
        }
        catch {
            XCTFail()
        }
    }
    
    func testThatSerializerYieldsBalanceObject() {
        let JSONObject = Resources.Balance.JSONObject
        let balance = try! Balance(representation: JSONObject)
        XCTAssertTrue(nearlyEqual(balance.balance, b: 3250.31))
        let date = dateFromString(balance.balance_date)
        XCTAssertNotNil(date)
    }
}

