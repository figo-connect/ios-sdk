//
//  Account.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public struct Account {
    init(JSON: [String: AnyObject]) {
        account_id = JSON["account_id"] as? String
        account_number = JSON["account_number"] as? String
        additional_icons = JSON["additional_icons"] as? [String: String]
        auto_sync = JSON["auto_sync"] as? Bool
        balance = JSON["bank_code"]
        bank_code = JSON["bank_code"] as? String
        bank_id = JSON["bank_id"] as? String
        bank_name = JSON["bank_name"] as? String
        bic = JSON["bic"] as? String
        currency = JSON["currency"] as? String
        iban = JSON["iban"] as? String
        icon = JSON["icon"] as? String
        in_total_balance = JSON["in_total_balance"] as? Bool
        name = JSON["name"] as? String
        owner = JSON["owner"] as? String
        preferred_tan_scheme = JSON["preferred_tan_scheme"]
        save_pin = JSON["save_pin"] as? Bool
        status = JSON["status"]
        supported_payments = JSON["supported_payments"]
        type = JSON["type"] as? String
    }
    
    let account_id: String?
    let account_number: String?
    let additional_icons: [String : String]?
    let auto_sync: Bool?
    let balance: AnyObject?
    let bank_code: String?
    let bank_id: String?
    let bank_name: String?
    let bic: String?
    let currency: String?
    let iban: String?
    let icon: String?
    let in_total_balance: Bool?
    let name: String?
    let owner: String?
    let preferred_tan_scheme: AnyObject?
    let save_pin: Bool?
    let status: AnyObject?
    let supported_payments: AnyObject?
    let type: String?
}


