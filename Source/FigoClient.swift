//
//  FigoClient.swift
//  Figo
//
//  Created by Christian König on 27.11.15.
//  Copyright © 2015 figo GmbH. All rights reserved.
//

import Foundation


/// Milliseconds between polling task states
internal let POLLING_INTERVAL_MSECS: Int64 = Int64(400) * Int64(NSEC_PER_MSEC)

/// Number of task state polling requests before giving up
internal let POLLING_COUNTDOWN_INITIAL_VALUE = 100 // 100 x 400 ms = 40 s

/// Name of certificate file for public key pinning
internal let CERTIFICATE_FILES = ["figo_2016, figo_2017"]


/**

 Represents a figo session, which after successful a login can be used to access all the figo Connect API's endpoints
 
 Applications that would like to access the figo Connect API have to register with us beforehand. If you would like to use figo Connect API in your application, please email us. We would love to hear from you what you have in mind and will generate a client identifier and client secret for your application without any bureaucracy.
 
 The first login has to be with credentials, after that you can login using the refresh token which you got from the credential login.
 
 - Note: A session will timeout 60 minutes after login.
 - Important: Completion handlers are NOT executed on the main thread
 
 */
public class FigoClient: NSObject {
    
    fileprivate lazy var session: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
    }()
    
    /// Used for Basic HTTP authentication, derived from CliendID and ClientSecret
    fileprivate var basicAuthCredentials: String?

    /// OAuth2 access token
    var accessToken: String?
    
    /// OAuth2 refresh token
    var refreshToken: String?
    
    /// Public keys extracted from certificate files in bundle
    lazy var publicKeys: [SecKey] = {
        return publicKeysForResources(CERTIFICATE_FILES)
    }()
    
    
    /**
     Create a FigoClient instance
     
     - Parameter clientID: Client ID
     - Parameter clientSecret: Client secret
     
     - Note: SSL pinning is implemented in the NSURLSessionDelegate. So if you provide your own NSURLSession, make sure to use FigoClient.dispositionForChallenge(:) in your own NSURLSessionDelegate to enable SSL pinning.
     */
    public convenience init(clientID: String, clientSecret: String) {
        self.init(clientID: clientID, clientSecret: clientSecret, session: nil, logger: nil)
    }
    
    /**
     Create a FigoClient instance
     
     - Parameter clientID: Client ID
     - Parameter clientSecret: Client secret
     - Parameter session: NSURLSession instance (Uses own instance by default)
     - Parameter logger: Logger instance (Logging disabled by default)
     
     - Note: SSL pinning is implemented in the NSURLSessionDelegate. So if you provide your own NSURLSession, make sure to use FigoClient.dispositionForChallenge(:) in your own NSURLSessionDelegate to enable SSL pinning.
     */
    public init(clientID: String, clientSecret: String, session: URLSession? = nil, logger: Logger? = nil) {
        super.init()
        
        self.basicAuthCredentials = base64EncodeBasicAuthCredentials(clientID, clientSecret)
        
        if let session = session {
            self.session = session
        }
        
        if let logger = logger {
            log = logger
        }
    }
    
    internal func request(_ endpoint: Endpoint, completion: @escaping (FigoResult<Data>) -> Void) {
        let mutableURLRequest = endpoint.URLRequest
        
        if endpoint.needsBasicAuthHeader {
            guard self.basicAuthCredentials != nil else {
                completion(.failure(FigoError(error: .noActiveSession)))
                return
            }
            mutableURLRequest.setValue("Basic \(self.basicAuthCredentials!)", forHTTPHeaderField: "Authorization")
        } else {
            guard self.accessToken != nil else {
                completion(.failure(FigoError(error: .noActiveSession)))
                return
            }
            mutableURLRequest.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        }
        
        debugPrintRequest(mutableURLRequest as URLRequest)
        
        let task = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let response = response as? HTTPURLResponse {
                
                debugPrintResponse(data, response, error)
                
                if case 200..<300 = response.statusCode  {
                    completion(.success(data ?? Data()))
                } else {
                    var serverError: FigoError = error != nil ?
                        FigoError(error: .networkLayerError(error: error!)) :
                        FigoError(error: .internalError(reason: "Unacceptable response status code (\(response.statusCode))"))
                    
                    if let data = data {
                        let json = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let dictionary = json as? [String: Any] {
                            if let error = dictionary["error"] as? [String: Any] {
                                if let error: FigoError = try? unbox(dictionary: error) {
                                    serverError = error
                                } else if let responseAsString = String(data: data, encoding: String.Encoding.utf8) {
                                    serverError = FigoError(error: .serverError(message: responseAsString))
                                }
                            }
                        }
                    }
                    
                    completion(.failure(serverError))
                }
            } else {
                if let error = error {
                    completion(.failure(FigoError(error: .networkLayerError(error: error))))
                } else {
                    completion(.failure(FigoError(error: .emptyResponse)))
                }

            }
        })
        task.resume()
    }
    
    /**
     Checks the server's certificates to make sure that you are really talking to the figo server
     */
    public func dispositionForChallenge(_ challenge: URLAuthenticationChallenge) -> URLSession.AuthChallengeDisposition {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            if !trustIsValid(serverTrust) {
                return .cancelAuthenticationChallenge
            }
            
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                let serverKeys = publicKeysForServerTrust(serverTrust) as NSArray
                for clientKey in self.publicKeys {
                    if serverKeys.contains(clientKey) {
                        return .performDefaultHandling
                    }
                }
                return .cancelAuthenticationChallenge
            }

        } else {
            if challenge.previousFailureCount > 0 {
                return .cancelAuthenticationChallenge
            }
        }
        
        return .performDefaultHandling
    }
}

extension FigoClient: URLSessionDelegate {
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(dispositionForChallenge(challenge), nil)
    }
}

private func publicKeyForCertificateData(_ data: Data) -> SecKey? {
    if let certificate = SecCertificateCreateWithData(nil, data as CFData) {
        var trust: SecTrust?
        let status = SecTrustCreateWithCertificates(certificate, SecPolicyCreateBasicX509(), &trust)
        if status == errSecSuccess {
            if let trust = trust {
                let key = SecTrustCopyPublicKey(trust)
                return key
            }
        }
    }
    return nil
}

private func publicKeysForServerTrust(_ serverTrust: SecTrust) -> [SecKey] {
    var keys: [SecKey] = []
    
    for index in 0 ..< SecTrustGetCertificateCount(serverTrust) {
        if let certificate = SecTrustGetCertificateAtIndex(serverTrust, index) {
            var trust: SecTrust?
            let status = SecTrustCreateWithCertificates(certificate, SecPolicyCreateBasicX509(), &trust)
            if status == errSecSuccess {
                if let trust = trust {
                    if let key = SecTrustCopyPublicKey(trust) {
                        keys.append(key)
                    }
                }
            }
        }
    }
    
    return keys
}

private func trustIsValid(_ trust: SecTrust) -> Bool {
    var isValid = false
    var result = SecTrustResultType.invalid
    let status = SecTrustEvaluate(trust, &result)
    
    if status == errSecSuccess {
        let unspecified = SecTrustResultType.unspecified
        let proceed = SecTrustResultType.proceed
        isValid = result == unspecified || result == proceed
    }
    return isValid
}

private func publicKeysForResources(_ resources: [String]) -> [SecKey] {
    var publicKeys: [SecKey] = []
    
    for resource in resources {
        let url = Bundle(for: FigoClient.self).url(forResource: resource, withExtension: "cer")!
        let data = try? Data(contentsOf: url)
        assert(data != nil, "Failed to load contents of certificate file '\(resource).cer'")
        let key = publicKeyForCertificateData(data!)
        assert(key != nil, "Failed to extract public key from certificate file '\(resource).cer'")
        if let key = key {
            publicKeys.append(key)
        }
    }
    
    return publicKeys
}
