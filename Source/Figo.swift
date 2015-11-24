//
//  Figo.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import Alamofire

public var isUserLoggedIn: Bool {
    get {
        return Session.sharedSession.authorization != nil
    }
}

public func login(accessToken accessToken: String) {
    // TODO: Refresh token
    Session.sharedSession.authorization = Authorization(demoAccessToken: accessToken)
}

public func login(username username: String, password: String, clientID: String, clientSecret: String, completionHandler: (authorization: Authorization?, error: FigoError?) -> Void) {
    fireRequest(Router.LoginUser(username: username, password: password, secret: base64Encode(clientID, clientSecret))).responseObject() { (authorization: Authorization?, error: FigoError?) -> Void in
        Session.sharedSession.authorization = authorization
        completionHandler(authorization: authorization, error: error)
    }
}

public func logout(completionHandler: (authorization: Authorization?, error: NSError?) -> Void) {
    fireRequest(Router.RevokeToken(token: Session.sharedSession.authorization?.access_token ?? "")).responseObject() { (authorization: Authorization?, error: FigoError?) in
        // TODO: Endpoint always sends error
        Session.sharedSession.authorization = nil
        completionHandler(authorization: nil, error: nil)
    }
}

public func retrieveAccount(accountID: String, completionHandler: (account: Account?, error: FigoError?) -> Void) {
    fireRequest(Router.RetrieveAccount(accountId: accountID)).responseObject(completionHandler)
}

public func retrieveAccounts(completionHandler: (accounts: [Account]?, error: FigoError?) -> Void) {
    fireRequest(Router.RetrieveAccounts).responseCollection(completionHandler)
}


enum Router: URLRequestConvertible {
    private static let baseURLString = "https://api.figo.me"
    
    case LoginUser(username: String, password: String, secret: String)
    case RefreshToken(token: String)
    case RevokeToken(token: String)
    case RetrieveAccount(accountId: String)
    case RetrieveAccounts
    
    var method: Alamofire.Method {
        switch self {
            case .RefreshToken, LoginUser:
                return .POST
            default:
                return .GET
        }
    }
    
    var path: String {
        switch self {
            case .LoginUser, .RefreshToken:
                return "/auth/token"
            case .RevokeToken:
                return "/auth/revoke"
            case .RetrieveAccount(let accountId):
                return "/rest/accounts/" + accountId
            case .RetrieveAccounts:
                return "/rest/accounts"
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let token = Session.sharedSession.accessToken {
            mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        switch self {
            case .LoginUser(let username, let password, let secret):
                mutableURLRequest.setValue("Basic \(secret)", forHTTPHeaderField: "Authorization")
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["username": username, "password" : password, "grant_type" : "password"]).0
            case .RefreshToken(let token):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["refresh_token": token]).0
            case .RevokeToken(let token):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["token": token]).0
            default:
                return mutableURLRequest
        }
    }
}


private func fireRequest(request: URLRequestConvertible) -> Request {
    return Alamofire.request(request).validate()
}

private func base64Encode(clientID: String, _ clientSecret: String) -> String {
    let clientCode: String = clientID + ":" + clientSecret
    let utf8str: NSData = clientCode.dataUsingEncoding(NSUTF8StringEncoding)!
    return utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn)
}

