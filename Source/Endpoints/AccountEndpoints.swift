//
//  AccountEndpoints.swift
//  Figo
//
//  Created by Christian König on 27.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


extension FigoSession {
    
    public func retrieveAccounts(completion: (accounts: [Account]?, error: Error?) -> Void) {
        request(.RetrieveAccounts) { (data, error) -> Void in
            let decoded: ([Account]?, Error?) = decodeCollection(data)
            completion(accounts: decoded.0, error: decoded.1 ?? error)
        }
    }
}

