//
//  PaymentParameters.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public struct PaymentParameters {
    
    let type: PaymentType
    let allowed_recipients: [String]
    let can_be_recurring: Bool
    let can_be_scheduled: Bool
    let max_purpose_length: Int
    let supported_file_formats: [String]
    let supported_text_keys: [Int]
    
    private enum Key: String, PropertyKey {
        case type
        case allowed_recipients
        case can_be_recurring
        case can_be_scheduled
        case max_purpose_length
        case supported_file_formats
        case supported_text_keys
    }
    
    public init(paymentType: PaymentType, representation: AnyObject) throws {
        let mapper = try PropertyMapper(representation, typeName: "\(self.dynamicType)")
        
        type                    = paymentType
        allowed_recipients      = try mapper.valueForKey(Key.allowed_recipients)
        can_be_recurring        = try mapper.valueForKey(Key.can_be_recurring)
        can_be_scheduled        = try mapper.valueForKey(Key.can_be_scheduled)
        max_purpose_length      = try mapper.valueForKey(Key.max_purpose_length)
        supported_file_formats  = try mapper.valueForKey(Key.supported_file_formats)
        
        // Special treatment for the key "supported_text_keys" because the server sometimes sends
        // numbers and sometimes sends strings for the values
        do {
            supported_text_keys = try mapper.valueForKey(Key.supported_text_keys)
        }
        catch {
            var stringKeys: [String] = try mapper.valueForKey(Key.supported_text_keys)
            stringKeys = stringKeys.filter() { return Int($0) != nil }
            supported_text_keys = stringKeys.map() { return Int($0)! }
        }
    }
}

extension PaymentParameters: ResponseCollectionSerializable {
    
    public static func collection(representation: AnyObject) throws -> [PaymentParameters] {
        guard let representation: [String: [String: AnyObject]] = representation as? [String: [String: AnyObject]] else {
            throw Error.JSONUnexpectedType(key: "supported_payments", typeName: "\(self.dynamicType)")
        }
        var paymentParameters = [PaymentParameters]()
        for (key, value) in representation {
            guard let type: PaymentType = PaymentType(rawValue: key) else {
                throw Error.JSONUnexpectedValue(key: "supported_payments", typeName: "\(self.dynamicType)")
            }
            let parameters = try PaymentParameters(paymentType: type, representation: value)
            paymentParameters.append(parameters)
        }
        return paymentParameters
    }
}

