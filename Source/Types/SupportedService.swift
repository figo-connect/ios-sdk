//
//  SupportedService.swift
//  Figo
//
//  Created by Christian König on 30.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct SupportedService {
    
    /// Human readable name of the service
    public let name: String
    
    /// surrogate bank code used for this service
    public let bank_code: String
    
    public let additional_icons: AnyObject
    
    /// URL to an logo of the bank, e.g. as a badge icon
    public let icon: AnyObject
}

extension SupportedService: ResponseObjectSerializable {
    
    init(representation: AnyObject) throws {
        let mapper = try Decoder(representation, typeName: "\(self.dynamicType)")
        
        name                = try mapper.valueForKeyName("name")
        bank_code           = try mapper.valueForKeyName("bank_code")
        additional_icons    = try mapper.valueForKeyName("additional_icons")
        icon                = try mapper.valueForKeyName("icon")
    }
}

extension SupportedService: ResponseCollectionSerializable {
    
    static func collection(representation: AnyObject) throws -> [SupportedService] {
        guard let dict: [String: AnyObject] = representation as? [String: AnyObject] else {
            throw FigoError.JSONUnexpectedRootObject(typeName: "\(self.dynamicType)")
        }
        guard let value = dict["services"] else {
            throw FigoError.JSONMissingMandatoryKey(key: "services", typeName: "\(self.dynamicType)")
        }
        guard let serviceRepresentations: [AnyObject] = value as? [AnyObject] else {
            throw FigoError.JSONMissingMandatoryValue(key: "services", typeName: "\(self.dynamicType)")
        }

        return try serviceRepresentations.map() {
            return try SupportedService(representation: $0)
        }
    }
}
