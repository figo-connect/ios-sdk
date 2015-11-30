//
//  TanScheme.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


public struct TanScheme  {
    
    public let medium_name: String
    public let name: String
    public let tan_scheme_id: String
    
    private enum Key: String, PropertyKey {
        case medium_name, name, tan_scheme_id
    }
}

extension TanScheme: JSONObjectConvertible {
    
    var JSONObject: [String: AnyObject] {
        var dict = Dictionary<String, AnyObject>()
        dict[Key.medium_name.rawValue] = medium_name
        dict[Key.name.rawValue] = name
        dict[Key.tan_scheme_id.rawValue] = tan_scheme_id
        return dict
    }
}

extension TanScheme: ResponseObjectSerializable {

    init(representation: AnyObject) throws {
        let mapper = try Decoder(representation, typeName: "\(self.dynamicType)")
        
        medium_name = try mapper.valueForKey(Key.medium_name)
        name = try mapper.valueForKey(Key.name)
        tan_scheme_id = try mapper.valueForKey(Key.tan_scheme_id)
    }
}

extension TanScheme: ResponseCollectionSerializable {
    
    static func collection(representation: AnyObject) throws -> [TanScheme] {
        guard let representation: [[String: AnyObject]] = representation as? [[String: AnyObject]] else {
            throw FigoError.JSONUnexpectedType(key: "supported_tan_schemes", typeName: "Account")
        }
        var schemes = [TanScheme]()
        for value in representation {
            let scheme = try TanScheme(representation: value)
            schemes.append(scheme)
        }
        return schemes
    }
}
