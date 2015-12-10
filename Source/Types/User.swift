//
//  User.swift
//  Figo
//
//  Created by Christian König on 23.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
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
    public let joinDate: Date?
    
    /// Two-letter code of preferred language. Only available when calling with scope user=ro or better.
    public let language: String?
    
    /// This flag indicates whether the figo Account plan is free or premium. Only available when calling with scope user=ro or better.
    public let premium: Bool?
    
    /// Timestamp of premium figo Account expiry. Only available when calling with scope user=ro or better.
    public let premiumExpiresOn: Date?
    
    /// Provider for premium subscription or Null if no subscription is active. Only available when calling with scope user=ro or better.
    public let premiumSubscription: String?
    
    /// If this flag is set then all local data must be cleared from the device and re-fetched from the figo Connect server. Only available when calling with scope user=ro or better.
    public let forceReset: Bool?
    
    /// Auto-generated recovery password. This response parameter will only be set once and only for the figo iOS app and only for legacy figo Accounts. The figo iOS app must display this recovery password to the user. Only available when calling with scope user=ro or better.
    public let recoveryPassword: String?
    
    /// Array of filters defined by the user
    public let filters: [AnyObject]?
    
    
    init(unboxer: Unboxer) {
        userID                 = unboxer.unbox("user_id")
        name                    = unboxer.unbox("name")
        email                   = unboxer.unbox("email")
        address                 = unboxer.unbox("address")
        verifiedEmail          = unboxer.unbox("verified_email")
        sendNewsletter         = unboxer.unbox("send_newsletter")
        joinDate               = unboxer.unbox("join_date")
        language                = unboxer.unbox("language")
        premium                 = unboxer.unbox("premium")
        premiumExpiresOn      = unboxer.unbox("premium_expires_on")
        premiumSubscription    = unboxer.unbox("premium_subscription")
        forceReset             = unboxer.unbox("force_reset")
        recoveryPassword       = unboxer.unbox("recovery_password")
        filters                 = unboxer.unbox("filters")
    }
}


