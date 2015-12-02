//
//  UnboxingTests.swift
//  Figo
//
//  Created by Christian König on 23.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
import Figo


class UnboxingTests: XCTestCase {
    
    func testIntTextKeys() {
        let JSONObject = Resources.PaymentParametersIntTextKeys.JSONObject
        let p: PaymentParameters? = Unbox(JSONObject)
        XCTAssertNotNil(p)
        XCTAssertEqual(p?.supported_text_keys?.count, 6)
    }
    
    func testStringTextKeys() {
        let JSONObject = Resources.PaymentParametersStringTextKeys.JSONObject
        let p: PaymentParameters? = Unbox(JSONObject)
        XCTAssertNotNil(p)
        XCTAssertEqual(p?.supported_text_keys_strings?.count, 6)
    }
    
    func testThatAccountSerializerYieldsObject() {
        let JSONObject = Resources.Account.JSONObject
        let account: Account = Unbox(JSONObject)!
        
        XCTAssertEqual(account.account_id, "A1.1")
        XCTAssertEqual(account.account_number, "4711951500")
        XCTAssertEqual(account.additional_icons.count, 2)
        XCTAssertEqual(account.auto_sync, false)
        XCTAssertEqual(account.balance!.balance, Int(325031))
        XCTAssertEqual(account.balance!.balance_date, "2013-09-11T00:00:00.000Z")
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
        XCTAssertEqual(account.status!.code, -1)
        XCTAssertEqual(account.status!.message, "Cannot load credential 8f084858-e1c6-4642-87f8-540b530b6e0f: UUID does not exist.")
        XCTAssertEqual(account.status!.success_timestamp, "2013-09-11T00:00:00.000Z")
        XCTAssertEqual(account.status!.sync_timestamp, "2014-07-09T10:04:40.000Z")
        XCTAssertEqual(account.supported_payments.count, 1)
        let (type, parameters) = account.supported_payments.first!
        XCTAssertEqual(type.rawValue, "Transfer")
        XCTAssertEqual(parameters.allowed_recipients.count, 0)
        XCTAssertEqual(parameters.can_be_recurring, false)
        XCTAssertEqual(parameters.can_be_scheduled, true)
        XCTAssertEqual(parameters.max_purpose_length, 108)
        XCTAssertEqual(parameters.supported_text_keys![0], 51)
        XCTAssertEqual(parameters.supported_text_keys![1], 53)
        XCTAssertEqual(account.supported_tan_schemes.count, 3)
        XCTAssertEqual(account.supported_tan_schemes.first?.medium_name, "")
        XCTAssertEqual(account.supported_tan_schemes.first?.name, "iTAN")
        XCTAssertEqual(account.supported_tan_schemes.last?.tan_scheme_id, "M1.3")
        XCTAssertEqual(account.type, "Unknown")
    }
    
    func testThatUserSerializerYieldsObject() {
        let JSONObject = Resources.User.JSONObject
        let user: User = Unbox(JSONObject)!
        
        XCTAssertEqual(user.address?.city, "Berlin")
        XCTAssertEqual(user.address?.company, "figo")
        XCTAssertEqual(user.address?.postal_code, "10969")
        XCTAssertEqual(user.address?.street, "Ritterstr. 2-3")
        XCTAssertEqual(user.email, "demo@figo.me")
        XCTAssertEqual(user.join_date, "2012-04-19T17:25:54.000Z")
        XCTAssertEqual(user.language, "en")
        XCTAssertEqual(user.name, "John Doe")
        XCTAssertEqual(user.premium, true)
        XCTAssertEqual(user.premium_expires_on, "2014-04-19T17:25:54.000Z")
        XCTAssertEqual(user.premium_subscription, "paymill")
        XCTAssertEqual(user.send_newsletter, true)
        XCTAssertEqual(user.user_id, "U12345")
        XCTAssertEqual(user.verified_email, true)
    }
    
    func testThatSerializerThrowsCorrectErrorForMissingMandatoryKeys() {
        var JSONJSONObject = Resources.Account.JSONObject
        JSONJSONObject.removeValueForKey("account_id")
        
        do {
            let account: Account = try UnboxOrThrow(JSONJSONObject)
            XCTAssertNil(account)
            XCTFail()
        }
        catch (let error as UnboxError) {
            XCTAssert(error.description.containsString("account_id"))
            print(error)
        }
        catch {
            XCTFail()
        }
    }
    
    func testThatSerializerYieldsBalanceObject() {
        let JSONObject = Resources.Balance.JSONObject
        let balance: Balance = Unbox(JSONObject)!
        XCTAssertEqual(balance.balance, 325031)
        let date = dateFromString(balance.balance_date)
        XCTAssertNotNil(date)
    }
    
    func testThatSerializerYieldsTanSchemeObject() {
        let JSONObject = Resources.TanScheme.JSONObject
        let scheme: TanScheme = Unbox(JSONObject)!
        XCTAssertEqual(scheme.medium_name, "Girocard")
        XCTAssertEqual(scheme.name, "chipTAN optisch")
        XCTAssertEqual(scheme.tan_scheme_id, "M1.2")
    }
    
    func testThatSerializerYieldsTaskStateObject() {
        let JSONObject = Resources.TaskState.JSONObject
        let scheme: TaskState = Unbox(JSONObject)!
        XCTAssertEqual(scheme.account_id, "A1182805.0")
    }
    
    func testTransactionUnboxing(){
        let data = Resources.Transaction.data
        do {
            let t: Transaction = try UnboxOrThrow(data)
            XCTAssertEqual(t.account_id, "A1.1")
            XCTAssertEqual(t.account_number, "4711951501")
            XCTAssertEqual(t.amount, -300000)
            XCTAssertEqual(t.bank_code, "90090042")
            XCTAssertEqual(t.bank_name, "Demobank")
            XCTAssertEqual(t.booked, true)
            XCTAssertEqual(t.booking_date, "2013-04-10T12:00:00.000Z")
            XCTAssertEqual(t.booking_text, "Lastschrift")
            XCTAssertEqual(t.creation_timestamp, "2013-04-10T08:21:36.000Z")
            XCTAssertEqual(t.currency, "EUR")
            XCTAssertEqual(t.modification_timestamp, "2013-04-11T13:54:02.000Z")
            XCTAssertEqual(t.name, "Dr. House Solutions GmbH")
            XCTAssertEqual(t.purpose, "Miete Vertragsnr. 12993")
            XCTAssertEqual(t.transaction_id, "T1.24")
            XCTAssertEqual(t.type.rawValue, "Direct debit")
            XCTAssertEqual(t.value_date, "2013-04-10T12:00:00.000Z")
            XCTAssertEqual(t.visited, true)
        }
        catch (let error as UnboxError) {
            XCTFail(error.description)
        }
        catch {
            XCTFail()
        }
    }
    
    func testSecurityUnboxing(){
        let data = Resources.Security.data
        do {
            let s: Security = try UnboxOrThrow(data)
            XCTAssertEqual(s.account_id, "A1182805.3")
            XCTAssertEqual(s.amount, 629465)
            XCTAssertEqual(s.amount_original_currency, 1050000)
            XCTAssertEqual(s.creation_timestamp, "2015-11-28T18:30:21.000Z")
            XCTAssertEqual(s.currency, "AUD")
            XCTAssertEqual(s.exchange_rate, 0.60)
            XCTAssertEqual(s.isin, "AU9876543210")
            XCTAssertEqual(s.market, "XASX")
            XCTAssertEqual(s.modification_timestamp, "2015-11-28T18:30:21.000Z")
            XCTAssertEqual(s.name, "Australian Domestic Bonds 1993 (2003) Ser. 10")
            XCTAssertEqual(s.price, 10500)
            XCTAssertEqual(s.price_currency, "EUR")
            XCTAssertEqual(s.purchase_price, 9975)
            XCTAssertEqual(s.purchase_price_currency, "EUR")
            XCTAssertEqual(s.quantity, 10000)
            XCTAssertEqual(s.security_id, "S1182805.1")
            XCTAssertEqual(s.trade_timestamp, "1999-05-28T22:59:59.000Z")
            XCTAssertEqual(s.visited, false)
            XCTAssertEqual(s.wkn, "")
        }
        catch (let error as UnboxError) {
            XCTFail(error.description)
        }
        catch {
            XCTFail()
        }
    }
    
    
}

