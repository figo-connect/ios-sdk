//
//  SessionManager.swift
//  Figo
//
//  Created by Christian König on 27.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation



public typealias VoidCompletionHandler = (FigoResult<Void>) -> Void


// Server's SHA1 fingerprints
private let trustedFingerprints = Set(["cfc1bc7f6a16092b10838ab0224f3a65d270d73e"])


/**
 Represents a Figo session, which has to be initialized with your client identifier and client secret.
 
 Applications that would like to access the figo Connect have to register with us beforehand. If you would like to use figo Connect in your application, please email us. We would love to hear from you what you have in mind and will generate a client identifier and client secret for your application without any bureaucracy.
 
 After a successfull login you can call all other functions as long as your session is valid. The first login has to be with credentials, after that you can login using the refresh token which you got from the credential login.
 
 - Important: A session will timeout 60 minutes after login.
 
 */
public class FigoSession {
    
    let sessionDelegate = FigoURLSessionDelegate()
    let session: NSURLSession
    
    // Used for Basic HTTP authentication, derived from CliendID and ClientSecret
    var basicAuthSecret: String?
    
    /// Milliseconds between polling task states
    let POLLING_INTERVAL_MSECS: Int64 = Int64(400) * Int64(NSEC_PER_MSEC)
    
    /// Number of task state polling requests before giving up
    let POLLING_COUNTDOWN_INITIAL_VALUE = 100 // 100 x 400 ms = 40 s
    
    var accessToken: String?
    var refreshToken: String?
    

    init() {
        session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: sessionDelegate, delegateQueue: nil)
    }
    
    func request(endpoint: Endpoint, completion: (FigoResult<NSData>) -> Void) {
        let mutableURLRequest = endpoint.URLRequest
        mutableURLRequest.setValue("2014-01-01", forHTTPHeaderField: "Figo-Version")
        
        if endpoint.needsBasicAuthHeader {
            guard self.basicAuthSecret != nil else {
                dispatch_async(dispatch_get_main_queue()) {
                    completion(.Failure(FigoError.NoActiveSession))
                }
                return
            }
            mutableURLRequest.setValue("Basic \(self.basicAuthSecret!)", forHTTPHeaderField: "Authorization")
        } else {
            guard self.accessToken != nil else {
                dispatch_async(dispatch_get_main_queue()) {
                    completion(.Failure(FigoError.NoActiveSession))
                }
                return
            }
            mutableURLRequest.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        }
        
        debugPrintRequest(mutableURLRequest)
        let task = session.dataTaskWithRequest(mutableURLRequest) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if let response = response as? NSHTTPURLResponse {
                
//                debugPrintResponse(data, response, error)
                
                if case 200..<300 = response.statusCode  {
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(.Success(data ?? NSData()))
                    }
                } else {
                    var serverError: FigoError = error != nil ? FigoError.NetworkLayerError(error: error!) : FigoError.UnspecifiedError(reason: "Unacceptable response status code (\(response.statusCode))")
                    if let data = data {
                        if let responseAsString = String(data: data, encoding: NSUTF8StringEncoding) {
                            serverError = FigoError.ServerError(message: responseAsString)
                            if let JSON = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) {
                                if let decodedError = try? FigoError(representation: JSON) {
                                    serverError = decodedError
                                }
                            }
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(.Failure(serverError))
                    }
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    if let error = error {
                        completion(.Failure(FigoError.NetworkLayerError(error: error)))
                    } else {
                        completion(.Failure(.EmptyResponse))
                    }
                }
            }
        }
        task.resume()
    }
}


class FigoURLSessionDelegate: NSObject, NSURLSessionDelegate {

    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
        
        var disposition: NSURLSessionAuthChallengeDisposition = .PerformDefaultHandling
        
        if let serverTrust = challenge.protectionSpace.serverTrust
        {
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
                let certificateData = certificateDataForTrust(serverTrust)
                let serverFingerprints = Set(certificateData.map() { return sha1($0) })
                if serverFingerprints.isDisjointWith(trustedFingerprints) {
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
        
        completionHandler(disposition, nil)
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
}



