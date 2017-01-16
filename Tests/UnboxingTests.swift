//
//  UnboxingTests.swift
//  Figo
//
//  Created by Christian König on 23.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import XCTest
@testable import Figo


class UnboxingTests: XCTestCase {
    
    func testIntTextKeys() {
        let JSONObject = Resources.PaymentParametersIntTextKeys.JSONObject
        let p: PaymentParameters? = try? unbox(dictionary: JSONObject)
        XCTAssertNotNil(p)
        XCTAssertEqual(p?.supportedTextKeys.count, 6)
    }
    
    func testStringTextKeys() {
        let JSONObject = Resources.PaymentParametersStringTextKeys.JSONObject
        let p: PaymentParameters? = try? unbox(dictionary: JSONObject)
        XCTAssertNotNil(p)
        XCTAssertEqual(p?.supportedTextKeys.count, 6)
    }
    
    func testThatAccountSerializerYieldsObject() {
        let JSONObject = Resources.Account.JSONObject
        let account: Account = try! unbox(dictionary: JSONObject)
        
        XCTAssertEqual(account.accountID, "A1.1")
        XCTAssertEqual(account.accountNumber, "4711951500")
        XCTAssertEqual(account.additionalIcons.count, 2)
        XCTAssertEqual(account.autoSync, false)
        XCTAssertEqual(account.balance!.balance, Int(325031))
        XCTAssertEqual(account.balance!.balanceDate?.timestamp, "2013-09-11T00:00:00.000Z")
        XCTAssertEqual(account.bankCode, "90090042")
        XCTAssertEqual(account.bankID, "B1.1")
        XCTAssertEqual(account.bankName, "Demobank")
        XCTAssertEqual(account.bic, "DEMODE01")
        XCTAssertEqual(account.currency, "EUR")
        XCTAssertEqual(account.iban, "DE67900900424711951500")
        XCTAssertEqual(account.icon, "https://api.figo.me/assets/images/accounts/default.png")
        XCTAssertEqual(account.inTotalBalance, true)
        XCTAssertEqual(account.name, "Girokonto")
        XCTAssertEqual(account.owner, "figo")
        XCTAssertNil(account.preferredTANScheme)
        XCTAssertEqual(account.savePin, false)
        XCTAssertEqual(account.status!.code, -1)
        XCTAssertEqual(account.status!.message, "Cannot load credential 8f084858-e1c6-4642-87f8-540b530b6e0f: UUID does not exist.")
        XCTAssertEqual(account.status!.successDate.timestamp, "2013-09-11T00:00:00.000Z")
        XCTAssertEqual(account.status!.syncDate.timestamp, "2014-07-09T10:04:40.000Z")
        XCTAssertEqual(account.supportedPayments.count, 1)
        let (type, parameters) = account.supportedPayments.first!
        XCTAssertEqual(type.rawValue, "Transfer")
        XCTAssertEqual(parameters.allowedRecipients!.count, 0)
        XCTAssertEqual(parameters.canBeRecurring, false)
        XCTAssertEqual(parameters.canBeScheduled, true)
        XCTAssertEqual(parameters.maxPurposeLength, 108)
        XCTAssertEqual(parameters.supportedTextKeys[0], 51)
        XCTAssertEqual(parameters.supportedTextKeys[1], 53)
        XCTAssertEqual(account.supportedTANSchemes.count, 3)
        XCTAssertEqual(account.supportedTANSchemes.first?.mediumName, "")
        XCTAssertEqual(account.supportedTANSchemes.first?.name, "iTAN")
        XCTAssertEqual(account.supportedTANSchemes.last?.TANSchemeID, "M1.3")
        XCTAssertEqual(account.type, AccountType.Unknown)

    }
    
    func testThatUserSerializerYieldsObject() {
        let JSONObject = Resources.User.JSONObject
        let user: User = try! unbox(dictionary: JSONObject)
        
        XCTAssertEqual(user.address?.city, "Berlin")
        XCTAssertEqual(user.address?.company, "figo")
        XCTAssertEqual(user.address?.postalCode, "10969")
        XCTAssertEqual(user.address?.street, "Ritterstr. 2-3")
        XCTAssertEqual(user.email, "demo@figo.me")
        XCTAssertEqual(user.joinDate?.timestamp, "2012-04-19T17:25:54.000Z")
        XCTAssertEqual(user.language, "en")
        XCTAssertEqual(user.name, "John Doe")
        XCTAssertEqual(user.premium, true)
        XCTAssertEqual(user.premiumExpiresOn?.timestamp, "2014-04-19T17:25:54.000Z")
        XCTAssertEqual(user.premiumSubscription, "paymill")
        XCTAssertEqual(user.sendNewsletter, true)
        XCTAssertEqual(user.userID, "U12345")
        XCTAssertEqual(user.verifiedEmail, true)
    }
    
    func testThatSerializerThrowsCorrectErrorForMissingMandatoryKeys() {
        var JSONObject = Resources.Account.JSONObject
        JSONObject.removeValue(forKey: "account_id")
        
        do {
            let account: Account = try unbox(dictionary: JSONObject)
            XCTAssertNil(account)
            XCTFail()
        }
        catch (let error as UnboxError) {
            XCTAssert(error.description.contains("account_id"))
            print(error)
        }
        catch {
            XCTFail()
        }
    }
    
    func testThatSerializerYieldsBalanceObject() {
        let JSONObject = Resources.Balance.JSONObject
        let balance: Balance = try! unbox(dictionary: JSONObject)
        XCTAssertEqual(balance.balance, 325031)
        XCTAssertNotNil(balance.balanceDate?.date)
        print(balance.balanceDate!)
    }
    
    func testThatSerializerYieldsTanSchemeObject() {
        let JSONObject = Resources.TanScheme.JSONObject
        let scheme: TANScheme = try! unbox(dictionary: JSONObject)
        XCTAssertEqual(scheme.mediumName, "Girocard")
        XCTAssertEqual(scheme.name, "chipTAN optisch")
        XCTAssertEqual(scheme.TANSchemeID, "M1.2")
    }
    
    func testThatSerializerYieldsTaskStateObject() {
        let JSONObject = Resources.TaskState.JSONObject
        let scheme: TaskState = try! unbox(dictionary: JSONObject)
        XCTAssertEqual(scheme.accountID, "A1182805.0")
    }
    
    func testTransactionUnboxing(){
        let data = Resources.Transaction.data
        do {
            let t: Transaction = try unbox(data: data)
            XCTAssertEqual(t.accountID, "A1.1")
            XCTAssertEqual(t.accountNumber, "4711951501")
            XCTAssertEqual(t.amount, -300000)
            XCTAssertEqual(t.bankCode, "90090042")
            XCTAssertEqual(t.bankName, "Demobank")
            XCTAssertEqual(t.booked, true)
            XCTAssertEqual(t.bookingDate!.timestamp, "2013-04-10T12:00:00.000Z")
            XCTAssertEqual(t.bookingText, "Lastschrift")
            XCTAssertEqual(t.creationDate.timestamp, "2013-04-10T08:21:36.000Z")
            XCTAssertEqual(t.currency, "EUR")
            XCTAssertEqual(t.modificationDate.timestamp, "2013-04-11T13:54:02.000Z")
            XCTAssertEqual(t.name, "Dr. House Solutions GmbH")
            XCTAssertEqual(t.purpose, "Miete Vertragsnr. 12993")
            XCTAssertEqual(t.transactionID, "T1.24")
            XCTAssertEqual(t.type, "Direct debit")
            XCTAssertEqual(t.valueDate?.timestamp ?? "", "2013-04-10T12:00:00.000Z")
            XCTAssertEqual(t.visited, true)
        }
        catch (let error as UnboxError) {
            XCTFail(error.description)
        }
        catch {
            XCTFail()
        }
    }
    
    func testSecurityUnboxing() {
        let data = Resources.Security.data
        do {
            let s: Security = try unbox(data: data)
            XCTAssertEqual(s.accountID, "A1182805.3")
            XCTAssertEqual(s.amount, 629465)
            XCTAssertEqual(s.amountOriginalCurrency, 1050000)
            XCTAssertEqual(s.creationDate.timestamp, "2015-11-28T18:30:21.000Z")
            XCTAssertEqual(s.currency, "AUD")
            XCTAssertEqual(s.exchangeRate, 0.60)
            XCTAssertEqual(s.isin, "AU9876543210")
            XCTAssertEqual(s.market, "XASX")
            XCTAssertEqual(s.modificationDate.timestamp, "2015-11-28T18:30:21.000Z")
            XCTAssertEqual(s.name, "Australian Domestic Bonds 1993 (2003) Ser. 10")
            XCTAssertEqual(s.price, 10500)
            XCTAssertEqual(s.priceCurrency, "EUR")
            XCTAssertEqual(s.purchasePrice, 9975)
            XCTAssertEqual(s.purchasePriceCurrency, "EUR")
            XCTAssertEqual(s.quantity, 10000)
            XCTAssertEqual(s.securityID, "S1182805.1")
            XCTAssertEqual(s.tradeDate.timestamp, "1999-05-28T22:59:59.000Z")
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
    
    func testStandingOrderUnboxing() {
        let data = Resources.StandingOrder.data
        do {
            let s: StandingOrder = try unbox(data: data)
            XCTAssertEqual(s.accountID, "A1.1")
        }
        catch (let error as UnboxError) {
            XCTFail(error.description)
        }
        catch {
            XCTFail()
        }
    }
    
}

