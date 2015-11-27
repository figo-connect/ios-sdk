//
//  SessionManager.swift
//  Figo
//
//  Created by Christian König on 27.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


extension FigoSession {
    
    /**
     CREDENTIAL LOGIN
     
     Requests authorization with credentials. Authorization can be obtained as long
     as the user has not revoked the access granted to your application.
     
     The returned refresh token can be stored by the client for future logins, but only
     in a securely encryped store like the keychain or a SQLCipher database.
     
     - parameter username: The figo account email address
     - parameter password: The figo account password
     - parameter completion: Returns refresh token or error
     */
    public func loginWithUsername(username: String, password: String, completion: (refreshToken: String?, error: Error?) -> Void) {
        figoRequest(Endpoint.LoginUser(username: username, password: password, secret: self.basicAuthSecret)) { (data, error) -> Void in
            let decoded: (Authorization?, Error?) = self.objectForData(data)
            self.accessToken = decoded.0?.access_token
            completion(refreshToken: decoded.0?.refresh_token, error: decoded.1 ?? error)
        }
    }
}


public class FigoSession {
    
    let session: NSURLSession = NSURLSession.sharedSession()
    let basicAuthSecret: String
    
    var accessToken: String?
    
    /**
     
     - parameter clientdID: The figo client identifier
     - parameter clientdSecret: The figo client sclient
     */
    public init(clientID: String, clientSecret: String) {
        basicAuthSecret = base64Encode(clientID, clientSecret)
    }
    
    public func retrieveAccounts(completion: (accounts: [Account]?, error: Error?) -> Void) {
        figoRequest(Endpoint.RetrieveAccounts) { (data, error) -> Void in
            let decoded: ([Account]?, Error?) = self.collectionForData(data)
            completion(accounts: decoded.0, error: decoded.1)
        }
    }
    
    func figoRequest(requestConvertible: URLRequestConvertible, completion: (data: NSData?, error: Error?) -> Void) {
        
        let mutableURLRequest = requestConvertible.URLRequest
        
        if requestConvertible.needsBasicAuthHeader {
            mutableURLRequest.setValue("Baisc \(basicAuthSecret)", forHTTPHeaderField: "Authorization")
        }

        figoPrintRequest(mutableURLRequest)
        
        session.dataTaskWithRequest(mutableURLRequest) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            let response = response as! NSHTTPURLResponse
            figoPrintResponse(data, response, error)
            
            if case 200..<300 = response.statusCode  {
                completion(data: data, error: nil)
            } else {
                var serverError: Error = error != nil ? Error.NetworkLayerError(error: error!) : Error.UnspecifiedError(reason: "Unacceptable response status code (\(response.statusCode))")
                if let data = data {
                    if let responseAsString = String(data: data, encoding: NSUTF8StringEncoding) {
                        serverError = Error.ServerError(message: responseAsString)
                        if let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) {
                            if let decodedError = try? Error(representation: JSON) {
                                serverError = decodedError
                            }
                        }
                    }
                }
                completion(data: nil, error: serverError)
            }
        }.resume()
    }
    
    func objectForData<T: ResponseObjectSerializable>(data: NSData?) -> (T?, Error?) {
        guard let data = data else { return (nil, nil) }
        do {
            let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
            if let decodedObject = try? T(representation: JSON) {
                return (decodedObject, nil)
            }
        } catch (let error as NSError) {
            return (nil, Error.JSONSerializationError(error: error))
        }
        return (nil, nil)
    }
    
    func collectionForData<T: ResponseCollectionSerializable>(data: NSData?) -> ([T]?, Error?) {
        guard let data = data else { return (nil, nil) }
        do {
            let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
            if let decodedCollection = try? T.collection(JSON) {
                return (decodedCollection, nil)
            }
        } catch (let error as NSError) {
            return (nil, Error.JSONSerializationError(error: error))
        }
        return (nil, nil)
    }
    
    

}
