//
//  CreateAccountParameters.swift
//  Figo
//
//  Created by Christian König on 01.12.15.
//  Copyright © 2015 figo GmbH. All rights reserved.
//


/**

Contains the parameters for setting up a new bank account

- Note: At least one of either `bankCode` or `iban` has to be set

*/
public struct CreateAccountParameters {
    
    /// **optional** Bank code
    public var bankCode: String?
    
    /// **optional** IBAN
    public var iban: String?
    
    /// **required** Two-letter country code (default: de)
    public var country: String = "de"
    
    /// **required** List of login credential strings. They must be in the same order as in the credentials list from the login settings
    public var credentials: [String]
    
    /// **required** This flag indicates whether the user has chosen to save the PIN on the figo Connect server. It is mandatory if the authentication type in the login settings of the bank code is pin and will be ignored otherwise.
    public var savePin: Bool
    
    /// **optional** This flag indicates whether the initial sync of the transactions and balances of the newly created accounts should be omitted. If this is the case certain listed accounts might actually be invalid (e.g. old creditcards) and will be automatically removed at the first sync.
    public var disableFirstSync: Bool?
    
    /// **optional** List of additional information to be fetched from the bank. Possible values are: standingOrders
    public var syncTasks: [String]?
    
    
    public init(bankCode: String?, iban: String?, country: String = "de", credentials: [String], savePin: Bool, disableFirstSync: Bool? = false, syncTasks: [String]? = nil) {
        self.bankCode = bankCode
        self.iban = iban
        self.country = country
        self.credentials = credentials
        self.savePin = savePin
        self.disableFirstSync = disableFirstSync
        self.syncTasks = syncTasks
    }
    
    var JSONObject: [String: AnyObject] {
        var dict = Dictionary<String, AnyObject>()
        dict["bank_code"] = bankCode as AnyObject?
        dict["iban"] = iban as AnyObject?
        dict["country"] = country as AnyObject?
        dict["credentials"] = credentials as AnyObject?
        dict["save_pin"] = savePin as AnyObject?
        dict["disable_first_sync"] = disableFirstSync as AnyObject?
        dict["sync_tasks"] = syncTasks as AnyObject?
        return dict
    }
}

