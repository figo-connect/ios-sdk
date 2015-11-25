//
//  Session.swift
//  Figo
//
//  Created by Christian König on 23.11.15.
//  Copyright © 2015 CodeStage. All rights reserved.
//

import Foundation


class Session {
    
    static let sharedSession: Session = {
        return Session()
    }()
    
    var authorization: Authorization?
    var secret: String?
    
    
    static func discardAuthorization() {
        Session.sharedSession.authorization = nil
    }
    
    static func discardAccessToken() {
        Session.sharedSession.authorization?.access_token = nil
    }
    
    // "device_name" : UIDevice.currentDevice().name, "device_type" : UIDevice.currentDevice().model, "device_udid" : NSUUID().UUIDString
}
