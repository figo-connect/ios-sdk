//
//  SerializerTests.swift
//  Figo
//
//  Created by Christian König on 23.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
import Figo


class SerializerTests: XCTestCase {

    func testIntTextKeys() {
        do {
            let JSONObject = Resources.PaymentParametersIntTextKeys.JSONObject
            let p = try PaymentParameters(paymentType: PaymentType.Transfer, representation: JSONObject)
            XCTAssertNotNil(p)
            XCTAssertEqual(p.supported_text_keys.count, 6)
        } catch {
            XCTFail()
        }
    }
    
    func testStringTextKeys() {
        do {
            let JSONObject = Resources.PaymentParametersStringTextKeys.JSONObject
            let p = try PaymentParameters(paymentType: PaymentType.Transfer, representation: JSONObject)
            XCTAssertNotNil(p)
            XCTAssertEqual(p.supported_text_keys.count, 6)
        } catch {
            XCTFail()
        }
    }
    
    func testThatAccountSerializerYieldsObject() {
        let JSONObject = Resources.Account.JSONObject
        let account = try! Account(representation: JSONObject)
        
        XCTAssertEqual(account.account_id, "A1.1")
        XCTAssertEqual(account.account_number, "4711951500")
        XCTAssertEqual(account.additional_icons.count, 2)
        XCTAssertEqual(account.auto_sync, false)
        XCTAssertTrue(nearlyEqual(account.balance.balance, b: 3250.31))
        XCTAssertEqual(account.balance.balance_date, "2013-09-11T00:00:00.000Z")
        XCTAssertEqual(account.bank_code, "90090042")
        XCTAssertEqual(account.bank_id, "B1.1")
        XCTAssertEqual(account.bank_name, "Demobank")
        XCTAssertEqual(account.bic, "DEMODE01")
        XCTAssertEqual(account.currency, "EUR")
        XCTAssertEqual(account.iban, "DE67900900424711951500")
        XCTAssertEqual(account.icon, "https://api.figo.me/assets/images/accounts/default.png")
        XCTAssertEqual(account.in_total_balance, true)
        XCTAssertEqual(account.name, "Girokonto")
        XCTAssertEqual(account.owner, "figo")
        XCTAssertNil(account.preferred_tan_scheme)
        XCTAssertEqual(account.save_pin, false)
        XCTAssertEqual(account.status.code, -1)
        XCTAssertEqual(account.status.message, "Cannot load credential 8f084858-e1c6-4642-87f8-540b530b6e0f: UUID does not exist.")
        XCTAssertEqual(account.status.success_timestamp, "2013-09-11T00:00:00.000Z")
        XCTAssertEqual(account.status.sync_timestamp, "2014-07-09T10:04:40.000Z")
        XCTAssertEqual(account.supported_payments.count, 1)
        XCTAssertEqual(account.supported_payments.first?.allowed_recipients.count, 0)
        XCTAssertEqual(account.supported_payments.first?.can_be_recurring, false)
        XCTAssertEqual(account.supported_payments.first?.can_be_scheduled, true)
        XCTAssertEqual(account.supported_payments.first?.max_purpose_length, 108)
        XCTAssertEqual(account.supported_payments.first?.supported_text_keys[0], 51)
        XCTAssertEqual(account.supported_payments.first?.supported_text_keys[1], 53)
        XCTAssertEqual(account.supported_tan_schemes.count, 3)
        XCTAssertEqual(account.supported_tan_schemes.first?.medium_name, "")
        XCTAssertEqual(account.supported_tan_schemes.first?.name, "iTAN")
        XCTAssertEqual(account.supported_tan_schemes.last?.tan_scheme_id, "M1.3")
        XCTAssertEqual(account.type, "Unknown")
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
    
    func testThatSerializerYieldsTanSchemeObject() {
        let JSONObject = Resources.TanScheme.JSONObject
        let scheme = try! TanScheme(representation: JSONObject)
        XCTAssertEqual(scheme.medium_name, "Girocard")
        XCTAssertEqual(scheme.name, "chipTAN optisch")
        XCTAssertEqual(scheme.tan_scheme_id, "M1.2")
    }
}

