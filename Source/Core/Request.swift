//
//  Requests.swift
//  Figo
//
//  Created by Christian König on 25.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


private enum Method: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

internal protocol JSONObjectConvertible {
    var JSONObject: [String: AnyObject] { get }
}


internal enum Endpoint {
    
    fileprivate static let baseURLString = "https://api.figo.me"
    
    case createNewFigoUser(CreateUserParameters)
    case loginUser(username: String, password: String)
    case deleteCurrentUser
    case retrieveCurrentUser
    
    case refreshToken(String)
    case revokeToken(String)
    
    case setupAccount(CreateAccountParameters)
    case retrieveAccounts
    case retrieveAccount(String)
    case removeStoredPin(bankID: String)
    case deleteAccount(String)
    
    case retrieveLoginSettings(countryCode: String, bankCode: String)
    case retrieveSupportedBanks(countryCode: String?)
    case retrieveSupportedServices(countryCode: String)

    case pollTaskState(PollTaskStateParameters)
    case synchronize([String: AnyObject])
    
    case retrieveTransactions(RetrieveTransactionsParameters)
    case retrieveTransactionsForAccount(String, parameters: RetrieveTransactionsParameters)
    case retrieveTransaction(String)
    
    case retrieveSecurities(RetrieveSecuritiesParameters)
    case retrieveSecuritiesForAccount(String, parameters: RetrieveSecuritiesParameters)
    case retrieveSecurity(String, accountID: String)
    
    case retrieveStandingOrders
    case retrieveStandingOrdersForAccount(String)
    case retrieveStandingOrder(String)

    case retrievePaymentProposals
    case retrievePayments
    case retrievePaymentsForAccount(String)
    case retrievePayment(String, accountID: String)
    case createPayment(CreatePaymentParameters)
    case modifyPayment(Payment)
    case submitPayment(Payment, tanSchemeID: String)


    fileprivate var method: Method {
        switch self {
        case .loginUser, .refreshToken, .createNewFigoUser, .revokeToken, .setupAccount, .pollTaskState, .removeStoredPin, .synchronize, .createPayment, .submitPayment:
            return .POST
        case .deleteCurrentUser, .deleteAccount:
            return .DELETE
        case .modifyPayment:
            return .PUT
        default:
            return .GET
        }
    }
    
    fileprivate var path: String {
        switch self {
        case .loginUser, .refreshToken:
            return "/auth/token"
        case .revokeToken:
            return "/auth/revoke"
        case .retrieveAccount(let accountId):
            return "/rest/accounts/" + accountId
        case .deleteAccount(let accountId):
            return "/rest/accounts/" + accountId
        case .retrieveAccounts, .setupAccount:
            return "/rest/accounts"
        case .retrieveCurrentUser, .deleteCurrentUser:
            return "/rest/user"
        case .createNewFigoUser:
            return "/auth/user"
        case .pollTaskState:
            return "/task/progress"
        case .removeStoredPin(let bankId):
            return "/rest/banks/\(bankId)/remove_pin"
        case .retrieveLoginSettings(let countryCode, let bankCode):
            return "/rest/catalog/banks/\(countryCode)/\(bankCode)"
        case .retrieveSupportedBanks(let countryCode):
            if let countryCode = countryCode {
                return "/catalog/banks/\(countryCode)"
            } else {
                return "/catalog/banks"
            }
        case .retrieveSupportedServices(let countryCode):
            return "/rest/catalog/services/\(countryCode)"
        case .synchronize:
            return "/rest/sync"
        case .retrieveTransactions:
            return "/rest/transactions"
        case .retrieveTransactionsForAccount(let accountID, _):
            return "/rest/accounts/\(accountID)/transactions"
        case .retrieveTransaction(let transactionID):
            return "/rest/transactions/\(transactionID)"
        case .retrieveSecurities:
            return "/rest/securities"
        case .retrieveSecuritiesForAccount(let accountID, _):
            return "/rest/accounts/\(accountID)/securities"
        case .retrieveSecurity(let securityID, let accountID):
            return "/rest/accounts/\(accountID)/securities/\(securityID)"
        case .retrieveStandingOrders:
            return "/rest/standing_orders"
        case .retrieveStandingOrdersForAccount(let accountID):
            return "/rest/accounts/\(accountID)/standing_orders"
        case .retrieveStandingOrder(let standingOrderID):
            return "/rest/standing_orders/\(standingOrderID)"
        case .createPayment(let parameters):
            return "/rest/accounts/\(parameters.accountID)/payments"
        case .modifyPayment(let payment):
            return "/rest/accounts/\(payment.accountID)/payments/\(payment.paymentID)"
        case .submitPayment(let payment, _):
            return "/rest/accounts/\(payment.accountID)/payments/\(payment.paymentID)/submit"
        case .retrievePaymentProposals:
            return "/rest/address_book"
        case .retrievePayments:
            return "/rest/payments"
        case .retrievePaymentsForAccount(let accountID):
            return "/rest/accounts/\(accountID)/payments"
        case .retrievePayment(let paymentID, let accountID):
            return "/rest/accounts/\(accountID)/payments/\(paymentID)"
        }
    }
    
    fileprivate var parameters: [String: AnyObject]? {
        switch self {
        case .loginUser(let username, let password):
            return ["username": username as AnyObject, "password": password as AnyObject, "grant_type": "password" as AnyObject]
        case .refreshToken(let token):
            return ["refresh_token": token as AnyObject, "grant_type": "refresh_token" as AnyObject]
        case .revokeToken(let token):
            return ["token": token as AnyObject, "cascade": false as AnyObject]
        case .createNewFigoUser(let user):
            return user.JSONObject
        case .setupAccount(let account):
            return account.JSONObject
        case .pollTaskState(let parameters):
            return parameters.JSONObject
        case .removeStoredPin(let bankId):
            return ["bank_id": bankId as AnyObject]
        case .retrieveAccount, .retrieveAccounts:
            return ["cents": true as AnyObject]
        case .synchronize(let parameters):
            return parameters
        case .retrieveTransactions(let parameters):
            return parameters.JSONObject
        case .retrieveTransactionsForAccount(_, let parameters):
            return parameters.JSONObject
        case .retrieveTransaction:
            return ["cents" : true as AnyObject]
        case .retrieveSecurities(let parameters):
            return parameters.JSONObject
        case .retrieveSecuritiesForAccount(_, let parameters):
            return parameters.JSONObject
        case .retrieveSecurity:
            return ["cents" : true as AnyObject]
        case .createPayment(let parameters):
            return parameters.JSONObject
        case .modifyPayment(let parameters):
            return parameters.JSONObject
        case .submitPayment(_, let tanSchemeID):
            return ["tan_scheme_id": tanSchemeID as AnyObject, "state": UUID().uuidString as AnyObject]
        case .retrievePayments, .retrievePayment, .retrievePaymentsForAccount:
            return ["cents" : false as AnyObject]
        default:
            return nil
        }
    }
    
    fileprivate func encodeParameters(_ request: NSMutableURLRequest) {
        switch self.method {
            
        case .POST, .PUT:
            // For some reason the id parameter needs to go into the query instead of the request body
            if case .pollTaskState(let parameters) = self {
                encodeURLParameters(request, ["id": parameters.taskToken as AnyObject])
            }
            guard let parameters = self.parameters else { return }
            let data = try? JSONSerialization.data(withJSONObject: parameters, options: [.prettyPrinted])
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            break
            
        case .GET, .DELETE:
            encodeURLParameters(request, parameters)
            break
            
        default:
            break
        }
    }
    
    internal var needsBasicAuthHeader: Bool {
        switch self {
        case .loginUser, .refreshToken, .revokeToken, .createNewFigoUser, .retrieveSupportedBanks:
            return true
        default:
            return false
        }
    }
    
    internal var URLRequest: NSMutableURLRequest {
        let URL = Foundation.URL(string: Endpoint.baseURLString)!
        let request = NSMutableURLRequest(url: URL.appendingPathComponent(path))
        request.httpMethod = self.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        encodeParameters(request)
        return request
    }
}


private func encodeURLParameters(_ request: NSMutableURLRequest, _ parameters: [String: AnyObject]?) {
    guard let parameters = parameters else { return }
    guard parameters.count > 0 else { return }
    
    var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)
    if components != nil {
        let percentEncodedQuery = (components?.percentEncodedQuery.map { $0 + "&" } ?? "") + queryStringForParameters(parameters)
        components?.percentEncodedQuery = percentEncodedQuery
        request.url = components?.url
    }
}

private func queryStringForParameters(_ parameters: [String: AnyObject]) -> String {
    var components: [(String, String)] = []
    for key in parameters.keys.sorted(by: <) {
        components.append((key, "\(parameters[key]!)"))
    }
    return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
}



