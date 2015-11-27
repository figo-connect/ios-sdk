//
//  Endpoint.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


func base64Encode(clientID: String, _ clientSecret: String) -> String {
    let clientCode: String = clientID + ":" + clientSecret
    let utf8str: NSData = clientCode.dataUsingEncoding(NSUTF8StringEncoding)!
    return utf8str.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn)
}

protocol URLRequestConvertible {
    var URLRequest: NSMutableURLRequest { get }
    var needsBasicAuthHeader: Bool { get }
}

enum Method: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

enum Endpoint: URLRequestConvertible {
    private static let baseURLString = "https://api.figo.me"
    
    case LoginUser(username: String, password: String, secret: String)
    case RefreshToken(token: String, secret: String)
    case RevokeToken(token: String)
    case RetrieveAccount(accountId: String)
    case RetrieveAccounts
    case RetrieveCurrentUser
    case CreateNewFigoUser(user: NewUser, secret: String)
    case SetupNewAccount(NewAccount)
    case PollTaskState(PollTaskStateParameters)
    case RemoveStoredPin(bankId: String)
    
    private var method: Method {
        switch self {
        case .LoginUser, .RefreshToken, .CreateNewFigoUser, .RevokeToken, .SetupNewAccount, .PollTaskState, .RemoveStoredPin:
            return .POST
        case .RetrieveAccount, .RetrieveAccounts, .RetrieveCurrentUser:
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
        case .RetrieveAccounts, .SetupNewAccount:
            return "/rest/accounts"
        case .RetrieveCurrentUser, .CreateNewFigoUser:
            return "/rest/user"
        case .PollTaskState:
            return "/task/progress"
        case .RemoveStoredPin(let bankId):
            return "/rest/banks/\(bankId)/remove_pin"
        }
    }
    
    private var parameters: [String: AnyObject] {
        switch self {
        case .LoginUser(let username, let password, _):
            return ["username": username, "password": password, "grant_type": "password"]
        case .RefreshToken(let token, _):
            return ["refresh_token": token, "grant_type": "refresh_token"]
        case .RevokeToken(let token):
            return ["token": token, "cascade": false]
        case .CreateNewFigoUser(let user, _):
            return user.JSONObject
        case .SetupNewAccount(let account):
            return account.JSONObject
        case .PollTaskState(let parameters):
            return parameters.JSONObject
        case .RemoveStoredPin(let bankId):
            return ["bank_id": bankId]
        default:
            return Dictionary<String, AnyObject>()
        }
    }
    
    private func encodeParameters(request: NSMutableURLRequest) {
        switch self.method {
        case .POST:
            do {
                let data = try NSJSONSerialization.dataWithJSONObject(self.parameters, options: NSJSONWritingOptions())
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.HTTPBody = data
            } catch { }
            break
        case .GET:
            func query(parameters: [String: AnyObject]) -> String {
                var components: [(String, String)] = []
                for key in parameters.keys.sort(<) {
                    components.append((key, "\(parameters[key]!)"))
                }
                return (components.map { "\($0)=\($1)" } as [String]).joinWithSeparator("&")
            }
            if let URLComponents = NSURLComponents(URL: request.URL!, resolvingAgainstBaseURL: false) {
                let percentEncodedQuery = (URLComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                URLComponents.percentEncodedQuery = percentEncodedQuery
                request.URL = URLComponents.URL
            }
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            break
        default:
            break
        }
    }
    
    var needsBasicAuthHeader: Bool {
        switch self {
        case .LoginUser, .RefreshToken, .RevokeToken, .CreateNewFigoUser:
            return true
        default:
            return false
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        let URL = NSURL(string: Endpoint.baseURLString)!
        let request = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        request.HTTPMethod = self.method.rawValue
        encodeParameters(request)
        return request
    }
    
    private func addSecretToHeader(secret: String, _ request: NSMutableURLRequest) {
        request.setValue("Basic \(secret)", forHTTPHeaderField: "Authorization")
        debugPrint("Basic has been set")
    }
}


