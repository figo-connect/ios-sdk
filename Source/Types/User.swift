//
//  User.swift
//  Figo
//
//  Created by Christian König on 23.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


public struct User: ResponseObjectSerializable {
    
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
    
    
    private enum Key: String, PropertyKey {
        case user_id
        case address
        case email
        case join_date
        case language
        case name
        case premium
        case premium_expires_on
        case premium_subscription
        case send_newsletter
        case verified_email
        case force_reset
        case recovery_password
        case filters
    }
    
    public init(representation: AnyObject) throws {
        let mapper = try Decoder(representation, typeName: "\(self.dynamicType)")
        
        user_id                 = try mapper.optionalValueForKey(Key.user_id)
        name                    = try mapper.valueForKey(Key.name)
        email                   = try mapper.valueForKey(Key.email)
        address                 = try Address(representation: mapper.optionalValueForKey(Key.address))
        verified_email          = try mapper.optionalValueForKey(Key.verified_email)
        send_newsletter         = try mapper.optionalValueForKey(Key.send_newsletter)
        join_date               = try mapper.optionalValueForKey(Key.join_date)
        language                = try mapper.optionalValueForKey(Key.language)
        premium                 = try mapper.optionalValueForKey(Key.premium)
        premium_expires_on      = try mapper.optionalValueForKey(Key.premium_expires_on)
        premium_subscription    = try mapper.optionalValueForKey(Key.premium_subscription)
        force_reset             = try mapper.optionalValueForKey(Key.force_reset)
        recovery_password       = try mapper.optionalValueForKey(Key.recovery_password)
        filters                 = try mapper.optionalValueForKey(Key.filters)
    }
    
}
