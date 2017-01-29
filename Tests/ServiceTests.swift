//
//  ServiceTests.swift
//  Figo
//
//  Created by Christian König on 29.01.17.
//  Copyright © 2017 CodeStage. All rights reserved.
//

import XCTest
@testable import Figo


class ServiceTests: BaseTestCaseWithLogin {
    
    func testRetrieveLoginSettings() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        login() {
            figo.retrieveLoginSettings(bankCode: "20090500") { result in
                XCTAssertNil(result.error)
                if case .success(let settings) = result {
                    XCTAssertTrue(settings.supported)
                    XCTAssertEqual(settings.authType, "pin")
                }
                
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testSupportedBanksUnboxing() {
        let data = Resources.SupportedBanks.data
        do {
            let envelope: BanksListEnvelope = try unbox(data: data)
            XCTAssertEqual(envelope.banks.first!.bankCode, 10000000)
            
        } catch (let error) {
            XCTAssertNil(error)
        }
    }
    
    func testThatRetrieveSupportedBanksWorksWithoutLogin() {
        self.waitForCompletionOfTests { (done) in
            figo.retrieveSupportedBanks(countryCode: "de") { result in
                XCTAssertNil(result.error)
                if case .success(let banks) = result {
                    XCTAssertNotNil(banks.first)
                    print("Received \(banks.count) banks")
                }
                done()
            }
        }
    }
    
    func testThatRetrieveSupportedBanksWorksWithLogin() {
        self.waitForCompletionOfTests { (done) in
            self.login {
                figo.retrieveSupportedBanks(countryCode: "de") { result in
                    XCTAssertNil(result.error)
                    if case .success(let banks) = result {
                        XCTAssertNotNil(banks.first)
                        print("Received \(banks.count) banks")
                    }
                    done()
                }
            }
        }
    }
    
    func testThatRetrieveSupportedBanksWorksWithoutCountryCode() {
        self.waitForCompletionOfTests { (done) in
            figo.retrieveSupportedBanks(countryCode: nil) { result in
                XCTAssertNil(result.error)
                if case .success(let banks) = result {
                    XCTAssertNotNil(banks.first)
                    print("Received \(banks.count) banks")
                }
                done()
            }
        }
    }
    
    func testThatRetrieveSupportedBanksWithUnsupportedCountryCodeYieldsEmptyArray() {
        self.waitForCompletionOfTests { (done) in
            figo.retrieveSupportedBanks(countryCode: "us") { result in
                XCTAssertNil(result.error)
                if case .success(let banks) = result {
                    XCTAssertNotNil(banks)
                    print("Received \(banks.count) banks")
                }
                done()
            }
        }
    }
    
    func testRetrieveSupportedServices() {
        let expectation = self.expectation(description: "Wait for all asyc calls to return")
        login() {
            figo.retrieveSupportedServices() { result in
                XCTAssertNil(result.error)
                if case .success(let services) = result {
                    let service = services.first!
                    debugPrint(service)
                }
                expectation.fulfill()
            }
        }
        self.waitForExpectations(timeout: 30, handler: nil)
    }
    
}
