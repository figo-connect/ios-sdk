//
//  Endpoints.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


private enum Method: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

enum Endpoint {
    private static let baseURLString = "https://api.figo.me"
    
    case CreateNewFigoUser(user: CreateUserParameters)
    case LoginUser(username: String, password: String)
    case DeleteCurrentUser
    case RetrieveCurrentUser
    case RefreshToken(token: String)
    case RevokeToken(token: String)
    case SetupCreateAccountParameters(CreateAccountParameters)
    case RetrieveAccounts
    case RetrieveAccount(accountId: String)
    case RemoveStoredPin(bankId: String)
    case BeginTask(taskToken: String)
    case PollTaskState(PollTaskStateParameters)

    
    private var method: Method {
        switch self {
        case .LoginUser, .RefreshToken, .CreateNewFigoUser, .RevokeToken, .SetupCreateAccountParameters, .PollTaskState, .RemoveStoredPin:
            return .POST
        case .RetrieveAccount, .RetrieveAccounts, .RetrieveCurrentUser, .BeginTask:
            return .GET
        case .DeleteCurrentUser:
            return .DELETE
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
        case .RetrieveAccounts, .SetupCreateAccountParameters:
            return "/rest/accounts"
        case .RetrieveCurrentUser, .DeleteCurrentUser:
            return "/rest/user"
        case .CreateNewFigoUser:
            return "/auth/user"
        case .PollTaskState:
            return "/task/progress"
        case .RemoveStoredPin(let bankId):
            return "/rest/banks/\(bankId)/remove_pin"
        case .BeginTask:
            return "/task/start"
        }
    }
    
    private var parameters: [String: AnyObject] {
        switch self {
        case .LoginUser(let username, let password):
            return ["username": username, "password": password, "grant_type": "password"]
        case .RefreshToken(let token):
            return ["refresh_token": token, "grant_type": "refresh_token"]
        case .RevokeToken(let token):
            return ["token": token, "cascade": false]
        case .CreateNewFigoUser(let user):
            return user.JSONObject
        case .SetupCreateAccountParameters(let account):
            return account.JSONObject
        case .PollTaskState(let parameters):
            return parameters.JSONObject
        case .RemoveStoredPin(let bankId):
            return ["bank_id": bankId]
        case .RetrieveAccount, .RetrieveAccounts:
            return ["cents": true]
        case .BeginTask(let taskToken):
            return ["id": taskToken]
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
        case .GET, .DELETE:
            if parameters.count > 0 {

            if let URLComponents = NSURLComponents(URL: request.URL!, resolvingAgainstBaseURL: false) {
                let percentEncodedQuery = (URLComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                URLComponents.percentEncodedQuery = percentEncodedQuery
                request.URL = URLComponents.URL
            }
            request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
            }
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
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        encodeParameters(request)
        return request
    }
}


private func query(parameters: [String: AnyObject]) -> String {
    var components: [(String, String)] = []
    for key in parameters.keys.sort(<) {
        components.append((key, "\(parameters[key]!)"))
    }
    return (components.map { "\($0)=\($1)" } as [String]).joinWithSeparator("&")
}



