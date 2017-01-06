//
//  ServiceEndpoints.swift
//  Figo
//
//  Created by Christian König on 30.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Unbox


public extension FigoClient {
    
    /**
     RETRIEVE LOGIN SETTINGS FOR A BANK OR SERVICE
     
     This only returns the bank accounts the user has chosen to share with your application
     
     - Parameter countryCode: The country the service comes from (Valid values: de)
     - Parameter bankCode: Bank code
     - Parameter completionHandler: Returns login settings or error
     */
    public func retrieveLoginSettings(_ countryCode: String = "de", bankCode: String, _ completionHandler: @escaping (Result<LoginSettings>) -> Void) {
        request(Endpoint.retrieveLoginSettings(countryCode: countryCode, bankCode: bankCode)) { response in
            completionHandler(decodeUnboxableResponse(response))
        }
    }
    
    /**
     RETRIEVE LIST OF SUPPORTED BANKS, CREDIT CARDS, OTHER PAYMENT SERVICES
     
     - Parameter countryCode: The country the service comes from (Valid values: de)
     */
    public func retrieveSupportedBanks(_ countryCode: String = "de", _ completionHandler: @escaping (Result<[SupportedBank]>) -> Void) {
        request(Endpoint.retrieveSupportedBanks(countryCode: countryCode)) { response in
            let envelopeUnboxingResult: Result<BanksListEnvelope> = decodeUnboxableResponse(response)
            
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
     
     These services do not use bank codes and are therefore listed seperatly. In order to provide a uniform interface for the remaining process, part of the response is a fake bank code, used as a surrogate for these services in our other calls.
     
     - Parameter countryCode: The country the service comes from (Valid values: de)
     */
    public func retrieveSupportedServices(_ countryCode: String = "de", _ completionHandler: @escaping (Result<[SupportedService]>) -> Void) {
        request(Endpoint.retrieveSupportedServices(countryCode: countryCode)) { response in
            let envelopeUnboxingResult: Result<ServicesListEnvelope> = decodeUnboxableResponse(response)
            
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
