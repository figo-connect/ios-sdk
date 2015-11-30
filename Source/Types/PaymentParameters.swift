//
//  PaymentParameters.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public enum PaymentType: String {
    case Transfer = "Transfer"
    case DirectDebit = "Direct debit"
    case SEPATransfer = "SEPA transfer"
    case SEPADirectDebit = "SEPA direct debit"
}

public struct PaymentParameters {
    
    public let type: PaymentType
    public let allowed_recipients: [String]
    public let can_be_recurring: Bool
    public let can_be_scheduled: Bool
    public let max_purpose_length: Int
    public let supported_file_formats: [String]
    public let supported_text_keys: [Int]
    
    init(paymentType: PaymentType, representation: AnyObject) throws {
        let mapper = try Decoder(representation, typeName: "\(self.dynamicType)")
        
        type                    = paymentType
        allowed_recipients      = try mapper.valueForKeyName("allowed_recipients")
        can_be_recurring        = try mapper.valueForKeyName("can_be_recurring")
        can_be_scheduled        = try mapper.valueForKeyName("can_be_scheduled")
        max_purpose_length      = try mapper.valueForKeyName("max_purpose_length")
        supported_file_formats  = try mapper.valueForKeyName("supported_file_formats")
        
        // Special treatment for the key "supported_text_keys" because the server sometimes sends
        // numbers and sometimes sends strings for the values
        do {
            supported_text_keys = try mapper.valueForKeyName("supported_text_keys")
        }
        catch {
            var stringKeys: [String] = try mapper.valueForKeyName("supported_text_keys")
            stringKeys = stringKeys.filter() { return Int($0) != nil }
            supported_text_keys = stringKeys.map() { return Int($0)! }
        }
    }
}

extension PaymentParameters: ResponseCollectionSerializable {
    
    static func collection(representation: AnyObject) throws -> [PaymentParameters] {
        guard let representation: [String: [String: AnyObject]] = representation as? [String: [String: AnyObject]] else {
            throw FigoError.JSONUnexpectedType(key: "supported_payments", typeName: "\(self.dynamicType)")
        }
        var paymentParameters = [PaymentParameters]()
        for (key, value) in representation {
            guard let type: PaymentType = PaymentType(rawValue: key) else {
                throw FigoError.JSONUnexpectedValue(key: "supported_payments", typeName: "\(self.dynamicType)")
            }
            let parameters = try PaymentParameters(paymentType: type, representation: value)
            paymentParameters.append(parameters)
        }
        return paymentParameters
    }
}

