//
//  FigoClient.swift
//  Figo
//
//  Created by Christian König on 27.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


// Server's SHA1 fingerprints
private let TRUSTED_FINGERPRINTS = Set(["38ae4a326f16ea1581338bb0d8e4a635e727f107"])

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
public class FigoClient {
    
    let sessionDelegate = FigoURLSessionDelegate()
    let session: NSURLSession
    
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
    public init(session: NSURLSession? = nil, logger: XCGLogger? = nil) {
        if let session = session {
            self.session = session
        } else {
            self.session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: sessionDelegate, delegateQueue: nil)
        }
        if let logger = logger {
            log = logger
        } else {
            log = XCGLogger.defaultInstance()
            log.setup(.None, showFunctionName: false, showDate: false, showThreadName: false, showLogLevel: false, showFileNames: false, showLineNumbers: false, writeToFile: nil, fileLogLevel: .None)
        }
    }
    
    func request(endpoint: Endpoint, completion: (Result<NSData>) -> Void) {
        let mutableURLRequest = endpoint.URLRequest
        
        if endpoint.needsBasicAuthHeader {
            guard self.basicAuthCredentials != nil else {
                completion(.Failure(Error.NoActiveSession))
                return
            }
            mutableURLRequest.setValue("Basic \(self.basicAuthCredentials!)", forHTTPHeaderField: "Authorization")
        } else {
            guard self.accessToken != nil else {
                completion(.Failure(Error.NoActiveSession))
                return
            }
            mutableURLRequest.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        }
        
        debugPrintRequest(mutableURLRequest)
        
        let task = session.dataTaskWithRequest(mutableURLRequest) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let response = response as? NSHTTPURLResponse {
                
                debugPrintResponse(data, response, error)
                
                if case 200..<300 = response.statusCode  {
                    completion(.Success(data ?? NSData()))
                } else {
                    var serverError: Error = error != nil ? .NetworkLayerError(error: error!) : .InternalError(reason: "Unacceptable response status code (\(response.statusCode))")
                    if let data = data {
                        if let responseAsString = String(data: data, encoding: NSUTF8StringEncoding) {
                            serverError = .ServerError(message: responseAsString)
                            if let unboxedError: Error = Unbox(data) {
                                serverError = unboxedError
                            }
                        }
                    }
                    completion(.Failure(serverError))
                }
            } else {
                if let error = error {
                    completion(.Failure(.NetworkLayerError(error: error)))
                } else {
                    completion(.Failure(.EmptyResponse))
                }

            }
        }
        task.resume()
    }
    
    
    /**
     Check's the server's certificates to make sure that you are really talking to the figo server
     */
    public class func dispositionForChallenge(challenge: NSURLAuthenticationChallenge) -> NSURLSessionAuthChallengeDisposition {
        
        var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
        
        if let serverTrust = challenge.protectionSpace.serverTrust
        {
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                let certificateData = certificateDataForTrust(serverTrust)
                let serverFingerprints = Set(certificateData.map() { return sha1($0) })
                if serverFingerprints.isDisjointWith(TRUSTED_FINGERPRINTS) {
                    disposition = .CancelAuthenticationChallenge
                }
            }
            if !trustIsValid(serverTrust) {
                disposition = .CancelAuthenticationChallenge
            }
        } else {
            if challenge.previousFailureCount > 0 {
                disposition = .CancelAuthenticationChallenge
            }
        }
        
        return disposition
    }
}


internal class FigoURLSessionDelegate: NSObject, NSURLSessionDelegate {
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        completionHandler(FigoClient.dispositionForChallenge(challenge), nil)
    }
}


private func sha1(data: NSData) -> String {
    var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
    CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
    let hexBytes = digest.map { String(format: "%02hhx", $0) }
    return hexBytes.joinWithSeparator("")
}

private func trustIsValid(trust: SecTrust) -> Bool {
    var isValid = false
    var result = SecTrustResultType(kSecTrustResultInvalid)
    let status = SecTrustEvaluate(trust, &result)
    
    if status == errSecSuccess {
        let unspecified = SecTrustResultType(kSecTrustResultUnspecified)
        let proceed = SecTrustResultType(kSecTrustResultProceed)
        isValid = result == unspecified || result == proceed
    }
    return isValid
}

private func certificateDataForTrust(trust: SecTrust) -> [NSData] {
    var certificates: [SecCertificate] = []
    
    for index in 0 ..< SecTrustGetCertificateCount(trust) {
        if let certificate = SecTrustGetCertificateAtIndex(trust, index) {
            certificates.append(certificate)
        }
    }
    return certificateDataForCertificates(certificates)
}

private func certificateDataForCertificates(certificates: [SecCertificate]) -> [NSData] {
    return certificates.map { SecCertificateCopyData($0) as NSData }
}

