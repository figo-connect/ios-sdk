//
//  SessionManager.swift
//  Figo
//
//  Created by Christian König on 27.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


/**
 Represents a Figo session, which has to be initialized with your client identifier and client secret.
 
 Applications that would like to access the figo Connect have to register with us beforehand. If you would like to use figo Connect in your application, please email us. We would love to hear from you what you have in mind and will generate a client identifier and client secret for your application without any bureaucracy.
 
 After a successfull login you can call all other functions as long as your session is valid. The first login has to be with credentials, after that you can login using the refresh token which you got from the credential login.
 
 - Important: A session will timeout 60 minutes after login.

 */
public class FigoSession {
    
    let session: NSURLSession = NSURLSession.sharedSession()
    let basicAuthSecret: String
    var accessToken: String?
    var refreshToken: String?
    
    
    /**
     Initializes a new Figo session
     
     - Parameter clientIdentifier: The figo client identifier
     - Parameter clientSecret: The figo client sclient
     */
    public init(clientIdentifier: String, clientSecret: String) {
        basicAuthSecret = base64Encode(clientIdentifier, clientSecret)
    }
    
    func request(endpoint: Endpoint, completion: (data: NSData?, error: Error?) -> Void) {
        let mutableURLRequest = endpoint.URLRequest
        if endpoint.needsBasicAuthHeader {
            mutableURLRequest.setValue("Basic \(self.basicAuthSecret)", forHTTPHeaderField: "Authorization")
        } else {
            guard self.accessToken != nil else {
                completion(data: nil, error: Error.NoActiveSession)
                return
            }
            mutableURLRequest.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        }

        debugPrintRequest(mutableURLRequest)
        session.dataTaskWithRequest(mutableURLRequest) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            let response = response as! NSHTTPURLResponse
            debugPrintResponse(data, response, error)
            
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
}


