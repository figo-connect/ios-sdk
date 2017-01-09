//
//  FigoClient.swift
//  Figo
//
//  Created by Christian König on 27.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


// Server's SHA1 fingerprints
private let TRUSTED_FINGERPRINTS = Set(["dbe2e9158fc9903084fe36caa61138d85a205d93"])

/// Milliseconds between polling task states
internal let POLLING_INTERVAL_MSECS: Int64 = Int64(400) * Int64(NSEC_PER_MSEC)

/// Number of task state polling requests before giving up
internal let POLLING_COUNTDOWN_INITIAL_VALUE = 100 // 100 x 400 ms = 40 s



/**

 Represents a figo session, which after successful a login can be used to access all the figo Connect API's endpoints
 
 Applications that would like to access the figo Connect API have to register with us beforehand. If you would like to use figo Connect API in your application, please email us. We would love to hear from you what you have in mind and will generate a client identifier and client secret for your application without any bureaucracy.
 
 The first login has to be with credentials, after that you can login using the refresh token which you got from the credential login.
 
 - Note: A session will timeout 60 minutes after login.
 - Important: Completion handlers are NOT executed on the main thread
 
 */
open class FigoClient {
    
    let sessionDelegate = FigoURLSessionDelegate()
    let session: URLSession
    
    // Used for Basic HTTP authentication, derived from CliendID and ClientSecret
    var basicAuthCredentials: String?

    /// OAuth2 access token
    var accessToken: String?
    
    /// OAuth2 refresh token
    var refreshToken: String?
    
    
    public convenience init() {
        self.init(session: nil, logger: nil)
    }
    
    /**
     Create a FigoClient instance
     
     - Parameter session: NSURLSession instance (Uses own instance by default)
     - Parameter logger: XCGLogger instance (Logging disabled by default)
     
     - Note: SSL pinning is implemented in the NSURLSessionDelegate. So if you provide your own NSURLSession, make sure to use FigoClient.dispositionForChallenge(:) in your own NSURLSessionDelegate to enable SSL pinning.
     */
    public init(session: URLSession? = nil, logger: Logger? = nil) {
        if let session = session {
            self.session = session
        } else {
            self.session = URLSession(configuration: URLSessionConfiguration.default, delegate: sessionDelegate, delegateQueue: nil)
        }
        if let logger = logger {
            log = logger
        }
    }
    
    func request(_ endpoint: Endpoint, completion: @escaping (Result<Data>) -> Void) {
        let mutableURLRequest = endpoint.URLRequest
        
        if endpoint.needsBasicAuthHeader {
            guard self.basicAuthCredentials != nil else {
                completion(.failure(FigoError.noActiveSession))
                return
            }
            mutableURLRequest.setValue("Basic \(self.basicAuthCredentials!)", forHTTPHeaderField: "Authorization")
        } else {
            guard self.accessToken != nil else {
                completion(.failure(FigoError.noActiveSession))
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
                    var serverError: FigoError = error != nil ? .networkLayerError(error: error!) : .internalError(reason: "Unacceptable response status code (\(response.statusCode))")
                    if let data = data {
                        if let responseAsString = String(data: data, encoding: String.Encoding.utf8) {
                            do {
                                serverError = try unbox(data: data)
                            } catch {
                                serverError = .serverError(message: responseAsString)
                            }
                        }
                    }
                    completion(.failure(serverError))
                }
            } else {
                if let error = error {
                    completion(.failure(.networkLayerError(error: error)))
                } else {
                    completion(.failure(.emptyResponse))
                }

            }
        })
        task.resume()
    }
    
    
    /**
     Check's the server's certificates to make sure that you are really talking to the figo server
     */
    open class func dispositionForChallenge(_ challenge: URLAuthenticationChallenge) -> URLSession.AuthChallengeDisposition {
        
        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        
        if let serverTrust = challenge.protectionSpace.serverTrust
        {
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                let certificateData = certificateDataForTrust(serverTrust)
                let serverFingerprints = Set(certificateData.map() { return sha1($0) })
                if serverFingerprints.isDisjoint(with: TRUSTED_FINGERPRINTS) {
                    disposition = .cancelAuthenticationChallenge
                }
            }
            if !trustIsValid(serverTrust) {
                disposition = .cancelAuthenticationChallenge
            }
        } else {
            if challenge.previousFailureCount > 0 {
                disposition = .cancelAuthenticationChallenge
            }
        }
        
        return disposition
    }
}


internal class FigoURLSessionDelegate: NSObject, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(FigoClient.dispositionForChallenge(challenge), nil)
    }
}


private func sha1(_ data: Data) -> String {
    var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
    CC_SHA1((data as NSData).bytes, CC_LONG(data.count), &digest)
    let hexBytes = digest.map { String(format: "%02hhx", $0) }
    return hexBytes.joined(separator: "")
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

private func certificateDataForTrust(_ trust: SecTrust) -> [Data] {
    var certificates: [SecCertificate] = []
    
    for index in 0 ..< SecTrustGetCertificateCount(trust) {
        if let certificate = SecTrustGetCertificateAtIndex(trust, index) {
            certificates.append(certificate)
        }
    }
    return certificateDataForCertificates(certificates)
}

private func certificateDataForCertificates(_ certificates: [SecCertificate]) -> [Data] {
    return certificates.map { SecCertificateCopyData($0) as Data }
}

