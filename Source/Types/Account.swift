//
//  Account.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


func stringForKey(key: String, representation: AnyObject) throws -> String {
    if let value = representation.valueForKeyPath(key) as? String {
        return value
    } else {
        throw SerializationError.MissingMandatoryKey(key: key)
    }
}


public struct Account: ResponseObjectSerializable, ResponseCollectionSerializable, CustomStringConvertible, CustomDebugStringConvertible {
    
    let account_id: String
    let account_number: String!
    let additional_icons: [String : String]!
    let auto_sync: Bool!
    let balance: AnyObject!
    let bank_code: String!
    let bank_id: String!
    let bank_name: String!
    let bic: String!
    let currency: String!
    let iban: String!
    let icon: String!
    let in_total_balance: Bool!
    let name: String!
    let owner: String!
    let preferred_tan_scheme: AnyObject!
    let save_pin: Bool!
    let status: AnyObject!
    let supported_payments: AnyObject!
    let type: String!
    
    private var representation: AnyObject
    
    public var description: String {
        get {
            return representation.description ?? ""
        }
    }
    
    public var debugDescription: String {
        get {
            return representation.debugDescription ?? ""
        }
    }
    
    public init?(response: NSHTTPURLResponse, representation: AnyObject) throws {
        try self.init(representation: representation)
    }
    
    public init?(representation: AnyObject) throws {
        self.representation = representation
        
        account_id = try stringForKey("account_id", representation: representation)
        account_number = representation.valueForKeyPath("account_number") as? String
        additional_icons = representation.valueForKeyPath("additional_icons") as? [String : String]
        auto_sync = representation.valueForKeyPath("auto_sync") as? Bool
        balance = representation.valueForKeyPath("balance")
        bank_code = representation.valueForKeyPath("bank_code") as? String
        bank_id = representation.valueForKeyPath("bank_id") as? String
        bank_name = representation.valueForKeyPath("bank_name") as? String
        bic = representation.valueForKeyPath("bic") as? String
        currency = representation.valueForKeyPath("currency") as? String
        iban = representation.valueForKeyPath("iban") as? String
        icon = representation.valueForKeyPath("icon") as? String
        in_total_balance = representation.valueForKeyPath("in_total_balance") as? Bool
        name = representation.valueForKeyPath("name") as? String
        owner = representation.valueForKeyPath("owner") as? String
        preferred_tan_scheme = representation.valueForKeyPath("preferred_tan_scheme")
        save_pin = representation.valueForKeyPath("save_pin") as? Bool
        status = representation.valueForKeyPath("status")
        supported_payments = representation.valueForKeyPath("supported_payments")
        type = representation.valueForKeyPath("type") as? String


    }
    
    public static func collection(response response: NSHTTPURLResponse, representation: AnyObject) throws -> [Account] {
        var accounts: [Account] = []
        if let representation = representation as? [String: AnyObject] {
            if let representation = representation["accounts"] as? [[String: AnyObject]] {
                for userRepresentation in representation {
                    if let account = try Account(response: response, representation: userRepresentation) {
                        accounts.append(account)
                    }
                }
            }
        }
        return accounts
    }
}


