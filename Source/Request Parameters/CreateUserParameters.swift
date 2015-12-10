//
//  CreateUserParameters.swift
//  Figo
//
//  Created by Christian König on 01.12.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//


/**

Parameters for the endpoint CREATE NEW FIGO USER

- Parameter name: **required** First and last name
- Parameter email: **required** Email address; It must obey the figo username & password policy
- Parameter password: **required** New figo Account password; It must obey the figo username & password policy
- Parameter sendNewsletter: **optional** This flag indicates whether the user has agreed to be contacted by email (optional)
- Parameter language: **optional** Two-letter code of preferred language (default: de)
- Parameter affiliateUser: **optional** Base64 encoded email address of the user promoting the new user
- Parameter affiliateClientID: **optional** Client ID of the figo Connect partner from which the user was redirected to the registration form

*/
public struct CreateUserParameters: JSONObjectConvertible {
    
    /// **required** First and last name
    public let name: String
    
    /// **required** Email address; It must obey the figo username & password policy
    public let email: String
    
    /// **required** New figo Account password; It must obey the figo username & password policy
    public let password: String
    
    /// **optional** This flag indicates whether the user has agreed to be contacted by email
    public let sendNewsletter: Bool?
    
    /// **optional** Two-letter code of preferred language (default: de)
    public let language: String?
    
    /// **optional** Base64 encoded email address of the user promoting the new user
    public let affiliateUser: String?
    
    /// **optional** Client ID of the figo Connect partner from which the user was redirected to the registration form
    public let affiliateClientID: String?
    

    init(name: String, email: String, password: String, sendNewsletter: Bool? = false, language: String? = "de", affiliateUser: String? = nil, affiliateClientID: String? = nil) {
        self.name = name
        self.email = email
        self.password = password
        self.sendNewsletter = sendNewsletter
        self.language = language
        self.affiliateUser = affiliateUser
        self.affiliateClientID = affiliateClientID
    }
    
    var JSONObject: [String: AnyObject] {
        get {
            var dict = Dictionary<String, AnyObject>()
            dict["name"] = name
            dict["email"] = email
            dict["send_newsletter"] = sendNewsletter
            dict["language"] = language
            dict["password"] = password
            dict["affiliate_user"] = affiliateUser
            dict["affiliate_client_id"] = affiliateClientID
            return dict
        }
    }
}
