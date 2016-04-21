//
//  DJ.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 4/17/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation

final class DJ : NSObject, NSCoding {
    
    let name: String
    let bio: String?
    let id: Int
    
    init(name: String, bio: String?, id: Int) {
        self.name = name
        self.bio = bio
        self.id = id
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInt(Int32(id), forKey: "id")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(bio, forKey: "bio")
    }
    
    required init(coder decoder: NSCoder) {
        id = Int(decoder.decodeIntForKey("id"))
        name = decoder.decodeObjectForKey("name") as! String
        bio = decoder.decodeObjectForKey("bio") as! String?
    }
    
}