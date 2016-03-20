//
//  FavoritesData.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 3/19/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation

struct FavoriteShow {
    let name: String
    let weeklyPlayings: [NSDate]
}

class FavoritesData {
    
    static let shared = FavoritesData()
    
    var subscribedShows: [FavoriteShow] = []
    
    init() {
        if dataShowList == nil {
            dataGetSchedule({data in
                log.debug("Schedule data loaded from Favorites Data.")
            })
        }
    }
    
}