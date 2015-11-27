//
//  NewAccount.swift
//  Figo
//
//  Created by Christian König on 26.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public struct NewAccount {
    
    /// Bank code (optional)
    public let bank_code: String?
    
    /// IBAN (optional)
    public let iban: String?
    
    /// Two-letter country code (valid values: de)
    let country: String = "de"
    
    /// List of login credential strings. They must be in the same order as in the credentials list from the login settings
    public let credentials: [String]
    
    /// This flag indicates whether the user has chosen to save the PIN on the figo Connect server. It is mandatory if the authentication type in the login settings of the bank code is pin and will be ignored otherwise.
    public let save_pin: Bool
    
    /// This flag indicates whether the initial sync of the transactions and balances of the newly created accounts should be omitted. If this is the case certain listed accounts might actually be invalid (e.g. old creditcards) and will be automatically removed at the first sync. (optional)
    public let disable_first_sync: Bool?
    
    /// List of additional information to be fetched from the bank. Possible values are: standingOrders (optional)
    public let sync_tasks: [String]?
    
    
    private enum Key: String, PropertyKey {
        case bank_code
        case iban
        case country
        case credentials
        case save_pin
        case disable_first_sync
        case sync_tasks
    }
    
}

extension NewAccount: JSONObjectConvertible {
    
//    func addOptional(optional: AnyObject?, var dict: Dictionary<String, AnyObject>, key: PropertyKey) {
//        if optional != nil {
//            dict[key.rawValue] = optional
//        }
//    }
    
    public var JSONObject: [String: AnyObject] {
        get {
            var dict = Dictionary<String, AnyObject>()
            dict[Key.bank_code.rawValue] = bank_code
            dict[Key.iban.rawValue] = iban
            dict[Key.country.rawValue] = country
            dict[Key.credentials.rawValue] = credentials
            dict[Key.save_pin.rawValue] = save_pin
            dict[Key.disable_first_sync.rawValue] = disable_first_sync
            dict[Key.sync_tasks.rawValue] = sync_tasks
            return dict
        }
    }
}