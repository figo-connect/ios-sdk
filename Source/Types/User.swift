//
//  User.swift
//  Figo
//
//  Created by Christian König on 23.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public struct User {
    
    /// Internal figo Connect user ID. Only available when calling with scope user=ro or better.
    public let user_id: String?

    /// First and last name
    public let name: String
    
    /// Email address
    public let email: String
    
    /// Postal address for bills, etc. Only available when calling with scope user=ro or better.
    public let address: Address?
    
    /// This flag indicates whether the email address has been verified. Only available when calling with scope user=ro or better.
    public let verified_email: Bool?

    /// This flag indicates whether the user has agreed to be contacted by email. Only available when calling with scope user=ro or better.
    public let send_newsletter: Bool?
    
    /// Timestamp of figo Account registration. Only available when calling with scope user=ro or better.
    public let join_date: String?
    
    /// Two-letter code of preferred language. Only available when calling with scope user=ro or better.
    public let language: String?
    
    /// This flag indicates whether the figo Account plan is free or premium. Only available when calling with scope user=ro or better.
    public let premium: Bool?
    
    /// Timestamp of premium figo Account expiry. Only available when calling with scope user=ro or better.
    public let premium_expires_on: String?
    
    /// Provider for premium subscription or Null if no subscription is active. Only available when calling with scope user=ro or better.
    public let premium_subscription: String?
    
    /// If this flag is set then all local data must be cleared from the device and re-fetched from the figo Connect server. Only available when calling with scope user=ro or better.
    public let force_reset: Bool?
    
    /// Auto-generated recovery password. This response parameter will only be set once and only for the figo iOS app and only for legacy figo Accounts. The figo iOS app must display this recovery password to the user. Only available when calling with scope user=ro or better.
    public let recovery_password: String?
    
    /// Array of filters defined by the user
    public let filters: [AnyObject]?
}

extension User: ResponseObjectSerializable {

    public init(representation: AnyObject) throws {
        let mapper = try Decoder(representation, typeName: "\(self.dynamicType)")
        
        user_id                 = try mapper.optionalForKeyName("user_id")
        name                    = try mapper.valueForKeyName("name")
        email                   = try mapper.valueForKeyName("email")
        address                 = try Address(optionalRepresentation: mapper.optionalForKeyName("address"))
        verified_email          = try mapper.optionalForKeyName("verified_email")
        send_newsletter         = try mapper.optionalForKeyName("send_newsletter")
        join_date               = try mapper.optionalForKeyName("join_date")
        language                = try mapper.optionalForKeyName("language")
        premium                 = try mapper.optionalForKeyName("premium")
        premium_expires_on      = try mapper.optionalForKeyName("premium_expires_on")
        premium_subscription    = try mapper.optionalForKeyName("premium_subscription")
        force_reset             = try mapper.optionalForKeyName("force_reset")
        recovery_password       = try mapper.optionalForKeyName("recovery_password")
        filters                 = try mapper.optionalForKeyName("filters")
    }
}

public struct CreateUserParameters: JSONObjectConvertible {
    
    /// First and last name
    public let name: String
    
    /// Email address; It must obey the figo username & password policy
    public let email: String
    
    /// New figo Account password; It must obey the figo username & password policy
    public let password: String
    
    /// This flag indicates whether the user has agreed to be contacted by email (optional)
    public let send_newsletter: Bool?
    
    /// Two-letter code of preferred language (optional, default: de)
    public let language: String?
    
    /// Base64 encoded email address of the user promoting the new user (optional)
    public let affiliate_user: String?
    
    /// Client ID of the figo Connect partner from which the user was redirected to the registration form (optional)
    public let affiliate_client_id: String?
    
    
    public var JSONObject: [String: AnyObject] {
        get {
            var dict = Dictionary<String, AnyObject>()
            dict["name"] = name
            dict["email"] = email
            dict["send_newsletter"] = send_newsletter
            dict["language"] = language
            dict["password"] = password
            dict["affiliate_user"] = affiliate_user
            dict["affiliate_client_id"] = affiliate_client_id
            return dict
        }
    }
}
