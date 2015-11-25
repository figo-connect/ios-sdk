//
//  User.swift
//  Figo
//
//  Created by Christian König on 23.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation

public final class User: ResponseObjectSerializable {
    
    let user_id: String?
    let address: [String : AnyObject]?
    let email: String?
    let join_date: String?
    let language: String?
    let name: String?
    let premium: Bool?
    let premium_expires_on: String?
    let premium_subscription: String?
    let send_newsletter: Bool?
    let verified_email: Bool?
    
    public init(representation: AnyObject) throws {
        user_id = representation.valueForKeyPath("user_id") as? String
        address = representation.valueForKeyPath("address") as? [String : AnyObject]
        email = representation.valueForKeyPath("email") as? String
        join_date = representation.valueForKeyPath("join_date") as? String
        language = representation.valueForKeyPath("language") as? String
        name = representation.valueForKeyPath("name") as? String
        premium = representation.valueForKeyPath("premium") as? Bool
        premium_expires_on = representation.valueForKeyPath("premium_expires_on") as? String
        premium_subscription = representation.valueForKeyPath("premium_subscription") as? String
        send_newsletter = representation.valueForKeyPath("send_newsletter") as? Bool
        verified_email = representation.valueForKeyPath("verified_email") as? Bool
    }
}

/*
{
"address": {
"city": "Berlin",
"company": "figo",
"postal_code": "10969",
"street": "Ritterstr. 2-3"
},
"email": "demo@figo.me",
"join_date": "2012-04-19T17:25:54.000Z",
"language": "en",
"name": "John Doe",
"premium": true,
"premium_expires_on": "2014-04-19T17:25:54.000Z",
"premium_subscription": "paymill",
"send_newsletter": true,
"user_id": "U12345",
"verified_email": true
}

*/