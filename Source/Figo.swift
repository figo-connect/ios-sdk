//
//  Figo.swift
//  Figo
//
//  Created by Christian König on 20.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation
import Alamofire

// MARK: Public Interface

public var isUserLoggedIn: Bool {
    get {
        return Session.sharedSession.authorization != nil
    }
}

public func login(accessToken accessToken: String) {
    // TODO: Refresh token
    Session.sharedSession.authorization = Authorization(demoAccessToken: accessToken)
}

public func login(username username: String, password: String, clientID: String, clientSecret: String, completionHandler: (authorization: Authorization?, error: Error?) -> Void) {
    fireRequest(Router.LoginUser(username: username, password: password, secret: base64Encode(clientID, clientSecret))).responseObject() { (authorization: Authorization?, error: Error?) -> Void in
        Session.sharedSession.authorization = authorization
        completionHandler(authorization: authorization, error: error)
    }
}

public func logout(completionHandler: (authorization: Authorization?, error: NSError?) -> Void) {
    fireRequest(Router.RevokeToken(token: Session.sharedSession.authorization?.access_token ?? "")).responseObject() { (authorization: Authorization?, error: Error?) in
        // TODO: Endpoint always sends error
        Session.sharedSession.authorization = nil
        completionHandler(authorization: nil, error: nil)
    }
}

public func retrieveAccount(accountID: String, completionHandler: (account: Account?, error: Error?) -> Void) {
    fireRequest(Router.RetrieveAccount(accountId: accountID)).responseObject(completionHandler)
}

public func retrieveAccounts(completionHandler: (accounts: [Account]?, error: Error?) -> Void) {
    fireRequest(Router.RetrieveAccounts).responseCollection(completionHandler)
}

// MARK: Private

private enum Router: URLRequestConvertible {
    private static let baseURLString = "https://api.figo.me"
    
    case LoginUser(username: String, password: String, secret: String)
    case RefreshToken(token: String)
    case RevokeToken(token: String)
    case RetrieveAccount(accountId: String)
    case RetrieveAccounts
    
    private var method: Alamofire.Method {
        switch self {
            case .RefreshToken, LoginUser:
                return .POST
            default:
                return .GET
        }
    }
    
    private var path: String {
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

    private var parameters: [String : AnyObject]? {
        switch self {
            case .LoginUser(let username, let password, _):
                return ["username": username, "password" : password, "grant_type" : "password"]
            case .RefreshToken(let token):
                return ["refresh_token": token]
            case .RevokeToken(let token):
                return ["token": token]
            default:
                return nil
        }
    }
    
    private func encodeParameters(request: NSMutableURLRequest) -> NSMutableURLRequest {
        switch self.method {
            case .GET:
                return Alamofire.ParameterEncoding.URL.encode(request, parameters: parameters).0
            default:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                return Alamofire.ParameterEncoding.JSON.encode(request, parameters: parameters).0
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Router.baseURLString)!
        let request = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        
        request.HTTPMethod = self.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let token = Session.sharedSession.accessToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        switch self {
            case .LoginUser(_, _, let secret):
                request.setValue("Basic \(secret)", forHTTPHeaderField: "Authorization")
                break
            default:
                break
        }
        
        return self.encodeParameters(request)
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

