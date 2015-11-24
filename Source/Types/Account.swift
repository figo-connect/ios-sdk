//
//  Account.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation

public struct Account: ResponseObjectSerializable, ResponseCollectionSerializable {
    
    let account_id: String
    let account_number: String
    let additional_icons: [String: String]!
    let auto_sync: Bool
    let balance: Balance
    let bank_code: String
    let bank_id: String
    let bank_name: String
    let bic: String
    let currency: String
    let iban: String
    let icon: String
    let in_total_balance: Bool
    let name: String
    let owner: String
    let preferred_tan_scheme: AnyObject!
    let save_pin: Bool!
    let status: AnyObject!
    let supported_payments: AnyObject!
    let type: String!

    private enum Key: String {
        case account_id
        case account_number
        case additional_icons
        case auto_sync
        case balance
        case bank_code
        case bank_id
        case bank_name
        case bic
        case currency
        case iban
        case icon
        case in_total_balance
        case name
        case owner
    }
    
    public init(response: NSHTTPURLResponse, representation: AnyObject) throws {
        try self.init(representation: representation)
    }
    
    public init(representation: AnyObject) throws {
        let mapper = try PropertyMapper(representation: representation, objectType: "\(self.dynamicType)")

        account_id          = try mapper.valueForKey(Key.account_id.rawValue)
        account_number      = try mapper.valueForKey(Key.account_number.rawValue)
        additional_icons    = representation.valueForKeyPath(Key.additional_icons.rawValue) as? [String: String]
        auto_sync           = try mapper.valueForKey(Key.auto_sync.rawValue)
        balance             = try Balance(representation: mapper.valueForKey(Key.balance.rawValue))
        bank_code           = try mapper.valueForKey(Key.bank_code.rawValue)
        bank_id             = try mapper.valueForKey(Key.bank_id.rawValue)
        bank_name           = try mapper.valueForKey(Key.bank_name.rawValue)
        bic                 = try mapper.valueForKey(Key.bic.rawValue)
        currency            = try mapper.valueForKey(Key.currency.rawValue)
        iban                = try mapper.valueForKey(Key.iban.rawValue)
        icon                = try mapper.valueForKey(Key.icon.rawValue)
        in_total_balance    = try mapper.valueForKey(Key.in_total_balance.rawValue)
        name                = try mapper.valueForKey(Key.name.rawValue)
        owner               = try mapper.valueForKey(Key.owner.rawValue)
        
        preferred_tan_scheme = representation.valueForKeyPath("preferred_tan_scheme")
        save_pin = representation.valueForKeyPath("save_pin") as? Bool
        status = representation.valueForKeyPath("status")
        supported_payments = representation.valueForKeyPath("supported_payments")
        type = representation.valueForKeyPath("type") as? String
    }
    
    var JSONObject: [String: AnyObject] {
        get {
            var dict = Dictionary<String, AnyObject>()
            dict[Key.account_id.rawValue] = account_id
            dict[Key.account_number.rawValue] = account_number
            return dict
        }
    }
    
    public static func collection(response response: NSHTTPURLResponse, representation: AnyObject) throws -> [Account] {
        var accounts: [Account] = []
        if let representation = representation as? [String: AnyObject] {
            if let representation = representation["accounts"] as? [[String: AnyObject]] {
                for userRepresentation in representation {
                    let account = try Account(response: response, representation: userRepresentation)
                    accounts.append(account)
                }
            }
        }
        return accounts
    }
}

extension Account: CustomStringConvertible {
    public var description: String {
        get {
            if let data = try? NSJSONSerialization.dataWithJSONObject(JSONObject, options: NSJSONWritingOptions.PrettyPrinted) {
                if let string = String(data: data, encoding: NSUTF8StringEncoding) {
                    return string
                }
            }
            return ""
        }
    }
}
