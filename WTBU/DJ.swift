//
//  DJ.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 4/17/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation

class DJ : NSObject, NSCoding {
    
    let name: String
    let bio: String?
    let id: Int
    
    init(name: String, bio: String?, id: Int) {
        self.name = name
        self.bio = bio
        self.id = id
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(Int32(id), forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(bio, forKey: "bio")
    }
    
    required init(coder decoder: NSCoder) {
        id = Int(decoder.decodeCInt(forKey: "id"))
        name = decoder.decodeObject(forKey: "name") as! String
        bio = decoder.decodeObject(forKey: "bio") as! String?
    }
    
}
