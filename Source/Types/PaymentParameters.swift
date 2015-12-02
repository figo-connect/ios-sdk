//
//  PaymentParameters.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct PaymentParameters: Unboxable {
    
    public let allowedRecipients: [String]
    public let canBeRecurring: Bool
    public let canBeScheduled: Bool
    public let maxPurposeLength: Int
    public let supportedFileFormats: [String]
    public let supportedTextKeys: [Int]?
    public let supportedTextKeysStrings: [String]?
    
    init(unboxer: Unboxer) {
        allowedRecipients      = unboxer.unbox("allowed_recipients")
        canBeRecurring        = unboxer.unbox("can_be_recurring")
        canBeScheduled        = unboxer.unbox("can_be_scheduled")
        maxPurposeLength      = unboxer.unbox("max_purpose_length")
        supportedFileFormats  = unboxer.unbox("supported_file_formats")
        
        // Special treatment for the key "supported_text_keys" because the server sometimes sends
        // numbers and sometimes sends strings for the values
        supportedTextKeys = unboxer.unbox("supported_text_keys")
        supportedTextKeysStrings = unboxer.unbox("supported_text_keys")
    }
}



