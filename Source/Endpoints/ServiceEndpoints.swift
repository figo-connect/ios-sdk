//
//  ServiceEndpoints.swift
//  Figo
//
//  Created by Christian König on 30.11.15.
//  Copyright © 2015 figo GmbH. All rights reserved.
//


public extension FigoClient {
    
    /**
     RETRIEVE LOGIN SETTINGS FOR A BANK OR SERVICE
     
     Does not require login.
     
     - Parameter countryCode: The country the service comes from (see API reference for valid values)
     - Parameter bankCode: Bank code
     - Parameter completionHandler: Returns login settings or error
     */
    public func retrieveLoginSettings(countryCode: String, bankCode: String, _ completionHandler: @escaping (FigoResult<LoginSettings>) -> Void) {
        request(Endpoint.retrieveLoginSettings(countryCode: countryCode, bankCode: bankCode)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
    /**
     RETRIEVE LIST OF SUPPORTED BANKS, CREDIT CARDS, OTHER PAYMENT SERVICES
     
     Does not require login. Very large response!
     
     - Parameter countryCode: The country the service comes from (see API reference for valid values)
     */
    public func retrieveSupportedBanks(countryCode: String? = nil, _ completionHandler: @escaping (FigoResult<[SupportedBank]>) -> Void) {
        request(Endpoint.retrieveSupportedBanks(countryCode: countryCode)) { response in
            let envelopeUnboxingResult: FigoResult<BanksListEnvelope> = decodeUnboxableResponse(response)
            
            switch envelopeUnboxingResult {
            case .success(let envelope):
                completionHandler(.success(envelope.banks))
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
    }
    
    /**
     RETRIEVE LIST OF SUPPORTED CREDIT CARDS AND OTHER PAYMENT SERVICES
     
     Does not require login.
     
     These services do not use bank codes and are therefore listed seperatly. In order to provide a uniform interface for the remaining process, part of the response is a fake bank code, used as a surrogate for these services in our other calls.
     
     - Parameter countryCode: The country the service comes from (see API reference for valid values)
     */
    public func retrieveSupportedServices(countryCode: String? = nil, _ completionHandler: @escaping (FigoResult<[SupportedService]>) -> Void) {
        request(Endpoint.retrieveSupportedServices(countryCode: countryCode)) { response in
            let envelopeUnboxingResult: FigoResult<ServicesListEnvelope> = decodeUnboxableResponse(response)
            
            switch envelopeUnboxingResult {
            case .success(let envelope):
                completionHandler(.success(envelope.services))
                break
            case .failure(let error):
                completionHandler(.failure(error))
                break
            }
        }
    }
    
    
}
