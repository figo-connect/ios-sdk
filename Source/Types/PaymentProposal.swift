//
//  PaymentProposal.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Unbox


public struct PaymentProposal: Unboxable {

    public let accountNumber: String
    public let bankCode: String
    public let name: String
    public let additionalIcons: [String: String]?
    public let icon: String
    
    public init(unboxer: Unboxer) throws {
        accountNumber = try unboxer.unbox(key: "account_number")
        bankCode = try unboxer.unbox(key: "bank_code")
        name = try unboxer.unbox(key: "name")
        additionalIcons = unboxer.unbox(key: "additional_icons")
        icon = try unboxer.unbox(key: "icon")
    }

}

