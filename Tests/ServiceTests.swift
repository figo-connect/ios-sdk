//
//  ServiceTests.swift
//  Figo
//
//  Created by Christian König on 29.01.17.
//  Copyright © 2017 figo GmbH. All rights reserved.
//

import XCTest
@testable import Figo


class ServiceTests: BaseTestCaseWithLogin {
    
    func testThatRetrieveLoginSettingsYieldsResult() {
        self.waitForCompletionOfTests() { done in
            figo.retrieveLoginSettings(countryCode: "de", bankCode: "10000000") { result in
                XCTAssertNil(result.error)
                if case .success(let settings) = result {
                    XCTAssertTrue(settings.supported)
                    XCTAssertEqual(settings.authType, "pin")
                }
                done()
            }
        }
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
    
    // MARK: - Supported banks
    
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
        self.waitForCompletionOfTests { done in
            figo.retrieveSupportedBanks(countryCode: "it") { result in
                XCTAssertNil(result.error)
                if case .success(let banks) = result {
                    XCTAssertNotNil(banks)
                    print("Received \(banks.count) banks")
                }
                done()
            }
        }
    }
    
    // MARK: - Supported services
    
    func testThatRetrieveSupportedServicesWorksWithoutLogin() {
        self.waitForCompletionOfTests { (done) in
            figo.retrieveSupportedServices(countryCode: "de") { result in
                XCTAssertNil(result.error)
                if case .success(let services) = result {
                    XCTAssertNotNil(services.first)
                    print("Received \(services.count) services")
                }
                done()
            }
        }
    }
    
    func testThatRetrieveSupportedServicesWorksWithLogin() {
        self.waitForCompletionOfTests { (done) in
            self.login {
                figo.retrieveSupportedServices(countryCode: "de") { result in
                    XCTAssertNil(result.error)
                    if case .success(let services) = result {
                        XCTAssertNotNil(services.first)
                        print("Received \(services.count) services")
                    }
                    done()
                }
            }
        }
    }
    
    func testThatRetrieveSupportedServicesWorksWithoutCountryCode() {
        self.waitForCompletionOfTests { (done) in
            figo.retrieveSupportedServices(countryCode: nil) { result in
                XCTAssertNil(result.error)
                if case .success(let services) = result {
                    XCTAssertNotNil(services.first)
                    print("Received \(services.count) services")
                }
                done()
            }
        }
    }
    
    func testThatRetrieveSupportedServicesWithUnsupportedCountryCodeYieldsEmptyArray() {
        self.waitForCompletionOfTests { done in
            figo.retrieveSupportedServices(countryCode: "it") { result in
                XCTAssertNil(result.error)
                if case .success(let services) = result {
                    XCTAssertNotNil(services)
                    print("Received \(services.count) services")
                }
                done()
            }
        }
    }
    
}
