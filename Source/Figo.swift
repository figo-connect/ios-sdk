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

public func loginWithUsername(username: String, password: String, clientID: String, clientSecret: String, completionHandler: (authorization: Authorization?, error: Error?) -> Void) {
    let secret = base64Encode(clientID, clientSecret)
    let request = Router.LoginUser(username: username, password: password, secret: secret)
    fireRequest(request).responseObject() { (authorization: Authorization?, error: Error?) -> Void in
        Session.sharedSession.authorization = authorization
        Session.sharedSession.secret = secret
        completionHandler(authorization: authorization, error: error)
    }
}

public func loginWithRefreshToken(refreshToken: String, clientID: String, clientSecret: String, completionHandler: (error: Error?) -> Void) {
    let secret = base64Encode(clientID, clientSecret)
    let request = Router.RefreshToken(token: refreshToken, secret: secret)
    fireRequest(request).responseObject() { (authorization: Authorization?, error: Error?) -> Void in
        Session.sharedSession.authorization = authorization
        Session.sharedSession.secret = secret
        completionHandler(error: error)
    }
}

private func refreshAccessToken(completionHandler: (error: Error?) -> Void) {
    guard let secret = Session.sharedSession.secret, let authorization = Session.sharedSession.authorization else {
        completionHandler(error: Error.NoLogin)
        return
    }
    let request = Router.RefreshToken(token: authorization.refresh_token!, secret: secret)
    fireRequest(request).responseObject() { (authorization: Authorization?, error: Error?) -> Void in
        Session.sharedSession.authorization = authorization
        Session.sharedSession.secret = secret
        completionHandler(error: error)
    }
}

public func revokeAccessToken(completionHandler: (error: Error?) -> Void) {
    fireRequest(Router.RevokeToken(token: Session.sharedSession.authorization?.access_token ?? ""))
        .response { request, response, data, error in
            debugPrintRequest(request, response, data)
            if let error = error {
                completionHandler(error: Error.NetworkLayerError(error: error))
            } else {
                completionHandler(error: nil)
            }
    }
}

public func revokeRefreshToken(token: String?, completionHandler: (error: Error?) -> Void) {
    let refreshToken: String = {
        if token != nil { return token! }
        else { return Session.sharedSession.authorization?.refresh_token ?? "" }
    }()
    fireRequest(Router.RevokeToken(token: refreshToken))
        .response { request, response, data, error in
            debugPrintRequest(request, response, data)
            if let error = error {
                completionHandler(error: Error.NetworkLayerError(error: error))
            } else {
                completionHandler(error: nil)
            }
    }
}

public func discardSession() {
    Session.sharedSession.authorization = nil
}

public func retrieveAccount(accountID: String, completionHandler: (account: Account?, error: Error?) -> Void) {
    let request = Router.RetrieveAccount(accountId: accountID)
    fireRequest(request).responseObject() { account, error in
        retryRequestingObjectOnInvalidTokenError(request, account, error, completionHandler)
    }
}

public func retrieveAccounts(completionHandler: (accounts: [Account]?, error: Error?) -> Void) {
    fireRequest(Router.RetrieveAccounts).responseCollection(completionHandler)
}

// MARK: Private


private func retryRequestingObjectOnInvalidTokenError<T: ResponseObjectSerializable>(request: URLRequestConvertible, _ object: T?, _ error: Error?, _ completionHandler: (T?, Error?) -> Void) {
    guard error != nil else {
        completionHandler(object, error)
        return
    }
    switch error! {
        case Error.ServerError(_):
            refreshAccessToken() { error -> Void in
                if error == nil {
                    fireRequest(request).responseObject(completionHandler)
                } else {
                    completionHandler(object, error)
                }
            }
            return
        default:
            break
    }
    completionHandler(object, error)
}

private func retryRequestingCollectionOnInvalidTokenError<T: ResponseObjectSerializable>(request: URLRequestConvertible, _ collection: Array<T>?, _ error: Error?, _ completionHandler: (Array<T>?, Error?) -> Void) {
    guard error != nil else {
        completionHandler(collection, error)
        return
    }
    switch error! {
    case Error.ServerError(_):

        refreshAccessToken() { error -> Void in
            if error == nil {
//                    fireRequest(request).responseCollection(completionHandler)
            } else {
                completionHandler(collection, error)
            }
        }
        return
    

    default:
        break
    }
    completionHandler(collection, error)
}

private enum Router: URLRequestConvertible {
    private static let baseURLString = "https://api.figo.me"
    
    case LoginUser(username: String, password: String, secret: String)
    case RefreshToken(token: String, secret: String)
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
            case .RevokeToken(_):
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
                return ["username": username, "password": password, "grant_type": "password"]
            case .RefreshToken(let token, _):
                return ["refresh_token": token, "grant_type": "refresh_token"]
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
        
        if let token = Session.sharedSession.authorization?.access_token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        switch self {
            case .LoginUser(_, _, let secret):
                request.setValue("Basic \(secret)", forHTTPHeaderField: "Authorization")
                break
            case .RefreshToken(_, let secret):
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

