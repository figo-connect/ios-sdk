//
//  PaymentProposal.swift
//  Figo
//
//  Created by Christian König on 02.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct PaymentProposal: Unboxable {

    public let account_number: String
    public let bank_code: String
    public let name: String
    public let additional_icons: [String: String]?
    public let icon: String
    
    init(unboxer: Unboxer) {
        account_number = unboxer.unbox("account_number")
        bank_code = unboxer.unbox("bank_code")
        name = unboxer.unbox("name")
        additional_icons = unboxer.unbox("additional_icons")
        icon = unboxer.unbox("icon")
    }

}

