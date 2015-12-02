//
//  PaymentProposal.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct PaymentProposal: Unboxable {

    public let accountNumber: String
    public let bankCode: String
    public let name: String
    public let additionalIcons: [String: String]?
    public let icon: String
    
    init(unboxer: Unboxer) {
        accountNumber = unboxer.unbox("account_number")
        bankCode = unboxer.unbox("bank_code")
        name = unboxer.unbox("name")
        additionalIcons = unboxer.unbox("additional_icons")
        icon = unboxer.unbox("icon")
    }

}

