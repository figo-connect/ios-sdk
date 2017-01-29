//
//  User.swift
//  Figo
//
//  Created by Christian König on 23.11.15.
//  Copyright © 2015 figo GmbH. All rights reserved.
//


public struct User: Unboxable {
    
    /// Internal figo Connect user ID. Only available when calling with scope user=ro or better.
    public let userID: String?

    /// First and last name
    public let name: String
    
    /// Email address
    public let email: String
    
    /// Postal address for bills, etc. Only available when calling with scope user=ro or better.
    public let address: Address?
    
    /// This flag indicates whether the email address has been verified. Only available when calling with scope user=ro or better.
    public let verifiedEmail: Bool?

    /// This flag indicates whether the user has agreed to be contacted by email. Only available when calling with scope user=ro or better.
    public let sendNewsletter: Bool?
    
    /// Timestamp of figo Account registration. Only available when calling with scope user=ro or better.
    public let joinDate: FigoDate?
    
    /// Two-letter code of preferred language. Only available when calling with scope user=ro or better.
    public let language: String?
    
    /// This flag indicates whether the figo Account plan is free or premium. Only available when calling with scope user=ro or better.
    public let premium: Bool?
    
    /// Timestamp of premium figo Account expiry. Only available when calling with scope user=ro or better.
    public let premiumExpiresOn: FigoDate?
    
    /// Provider for premium subscription or Null if no subscription is active. Only available when calling with scope user=ro or better.
    public let premiumSubscription: String?
    
    /// If this flag is set then all local data must be cleared from the device and re-fetched from the figo Connect server. Only available when calling with scope user=ro or better.
    public let forceReset: Bool?
    
    /// Auto-generated recovery password. This response parameter will only be set once and only for the figo iOS app and only for legacy figo Accounts. The figo iOS app must display this recovery password to the user. Only available when calling with scope user=ro or better.
    public let recoveryPassword: String?
    
    /// Array of filters defined by the user
    public let filters: [AnyObject]?
    
    
    init(unboxer: Unboxer) throws {
        userID                 = unboxer.unbox(key: "user_id")
        name                   = try unboxer.unbox(key: "name")
        email                  = try unboxer.unbox(key: "email")
        address                = unboxer.unbox(key: "address")
        verifiedEmail          = unboxer.unbox(key: "verified_email")
        sendNewsletter         = unboxer.unbox(key: "send_newsletter")
        joinDate               = unboxer.unbox(key: "join_date")
        language               = unboxer.unbox(key: "language")
        premium                = unboxer.unbox(key: "premium")
        premiumExpiresOn       = unboxer.unbox(key: "premium_expires_on")
        premiumSubscription    = unboxer.unbox(key: "premium_subscription")
        forceReset             = unboxer.unbox(key: "force_reset")
        recoveryPassword       = unboxer.unbox(key: "recovery_password")
        filters                = unboxer.unbox(key: "filters")
    }
}


