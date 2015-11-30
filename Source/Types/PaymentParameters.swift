//
//  PaymentParameters.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//




public struct PaymentParameters: Unboxable {
    
    public let allowed_recipients: [String]
    public let can_be_recurring: Bool
    public let can_be_scheduled: Bool
    public let max_purpose_length: Int
    public let supported_file_formats: [String]
    public let supported_text_keys: [Int]?
    public let supported_text_keys_strings: [String]?
    
    init(unboxer: Unboxer) {
        allowed_recipients      = unboxer.unbox("allowed_recipients")
        can_be_recurring        = unboxer.unbox("can_be_recurring")
        can_be_scheduled        = unboxer.unbox("can_be_scheduled")
        max_purpose_length      = unboxer.unbox("max_purpose_length")
        supported_file_formats  = unboxer.unbox("supported_file_formats")
        
        // Special treatment for the key "supported_text_keys" because the server sometimes sends
        // numbers and sometimes sends strings for the values
        supported_text_keys = unboxer.unbox("supported_text_keys")
        supported_text_keys_strings = unboxer.unbox("supported_text_keys")
    }
}



