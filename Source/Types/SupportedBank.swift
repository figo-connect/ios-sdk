//
//  SupportedService.swift
//  Figo
//
//  Created by Christian König on 30.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct SupportedBank {
    
    public let bank_name: String

    public let bank_code: Int
    
    public let bic: String
    
    public let icon: AnyObject
    
    public let credentials: [LoginCredentials]
    
    public let advice: String
}

extension SupportedBank: ResponseObjectSerializable {
    
    init(representation: AnyObject) throws {
        let mapper = try Decoder(representation, typeName: "\(self.dynamicType)")
        
        bank_name   = try mapper.valueForKeyName("bank_name")
        bank_code   = try mapper.valueForKeyName("bank_code")
        bic         = try mapper.valueForKeyName("bic")
        icon        = try mapper.valueForKeyName("icon")
        credentials = try LoginCredentials.collection(mapper.valueForKeyName("credentials"))
        advice      = try mapper.valueForKeyName("advice")

    }
}

extension SupportedBank: ResponseCollectionSerializable {

    static func collection(representation: AnyObject) throws -> [SupportedBank] {
        guard let dict: [String: AnyObject] = representation as? [String: AnyObject] else {
            throw FigoError.JSONUnexpectedRootObject(typeName: "\(self.dynamicType)")
        }
        guard let value = dict["banks"] else {
            throw FigoError.JSONMissingMandatoryKey(key: "banks", typeName: "\(self.dynamicType)")
        }
        guard let bankRepresentations: [AnyObject] = value as? [AnyObject] else {
            throw FigoError.JSONMissingMandatoryValue(key: "banks", typeName: "\(self.dynamicType)")
        }
        
        return try bankRepresentations.map() {
            return try SupportedBank(representation: $0)
        }
    }
}

