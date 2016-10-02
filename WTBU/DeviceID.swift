//
//  DeviceID.swift
//  WTBU
//
//  Created by Calvin Rose on 10/2/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation

// This class manages identity with respect to the WTBU app.
// For example, it is responsible for keeping track of the unique ID
// for this device.
class DeviceID {
    
    static let uuidKey = "deviceUUID"
    static let shared = DeviceID()
    let uuid: String
    
    init() {
        if let maybeUuid = UserDefaults.standard.string(forKey: DeviceID.uuidKey) {
            uuid = maybeUuid
        } else {
            uuid = UUID().uuidString
            UserDefaults.standard.set(uuid, forKey: DeviceID.uuidKey)
        }
    }
    
}
