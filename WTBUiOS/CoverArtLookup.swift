//
//  CoverArtLookup.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 2/2/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

class CoverArtLookup {
    
    static func getArt(artist: String, song: String) {
        
        let query = "\(artist), \(song)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        let url = "https://itunes.apple.com/search?term=\(query)"
        
        
    }
    
}