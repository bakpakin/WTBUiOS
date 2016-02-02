//
//  CoverArtLookup.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 2/2/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Alamofire
import SwiftyJSON

class CoverArtLookup {
    
    static func getArt(artist: String, song: String) {
        
        Alamofire.request(.GET, "https://itunes.apple.com/search", parameters: ["term": "\(artist) \(song)"])
            .responseJSON { response in
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
        
        
    }
    
}