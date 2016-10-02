//
//  Schedule.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 4/17/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import XCGLogger
import UIKit

public class Schedule : NSObject, NSCoding {
    
    static let defaultSchedule: Schedule = Schedule()
    
    let favoritesKey = "favoriteShows"
    let showsKey = "allShows"
    let lastLoadedFromBackend = "lastLoadedFromBackend"
    
    var shows: [Show]
    
    public override init() {
        shows = []
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(shows, forKey: "shows")
    }
    
    required public init(coder decoder: NSCoder) {
        self.shows = (decoder.decodeObject(forKey: "show") as? [Show]) ?? []
    }
    
    private func loadFavoritesData() {
        if let favShows = UserDefaults.standard.object(forKey: favoritesKey) as? [Int] {
            for show in shows {
                if favShows.contains(show.id) {
                    show.favorited = true
                }
            }
        }
    }
    
    func saveToUserDefaults() {
        var favorites = [Int]()
        for show in shows {
            if show.favorited {
                favorites.append(show.id)
            }
        }
        UserDefaults.standard.setValue(favorites, forKey: favoritesKey)
        UserDefaults.standard.setValue(NSKeyedArchiver.archivedData(withRootObject: shows), forKey: showsKey)
    }
    
    func loadFromUserDefaults() -> Bool {
        
        // If this code is getting buggy, such as the schedule not loading sometimes, just uncomment the next line.
        // return false
        
        if let lastBackendLoad = UserDefaults.standard.object(forKey: lastLoadedFromBackend) as? Date {
            // If has been less than 3 days since last backend load.
            // This ensures that users don't get really old data.
            XCGLogger.default.debug("Last loaded from backend: \(lastBackendLoad.description)")
            if Date().timeIntervalSince(lastBackendLoad) < 86400 * 3 {
                if let showsData = UserDefaults.standard.object(forKey: showsKey) as? Data {
                    let shows = NSKeyedUnarchiver.unarchiveObject(with: showsData) as? [Show]
                    if shows == nil {
                        return false
                    }
                    self.shows = shows!
                    self.loadFavoritesData()
                    return true
                }
            }
        }
        // Remove any potentially bad cache data just in case.
        UserDefaults.standard.removeObject(forKey: showsKey)
        UserDefaults.standard.removeObject(forKey: lastLoadedFromBackend)
        return false
    }
    
    func loadFromBackend(callback: ((Schedule)->Void)?) {
        Alamofire.request("https://gaiwtbubackend.herokuapp.com/regularShowsInfo", method: .get).responseJSON {
            response in
            if let nativeJson = response.result.value {
                let json = JSON(nativeJson)
                if let results = json["results"].array {
                    var foundShows = Set<Int>()
                    for showJson in results {
                        let show = Show(json: showJson)
                        if !foundShows.contains(show.id) {
                            self.shows.append(Show(json: showJson))
                            foundShows.insert(show.id)
                        }
                    }
                    UserDefaults.standard.setValue(Date(), forKey: self.lastLoadedFromBackend)
                    self.saveToUserDefaults()
                    if let cb = callback {
                        return cb(self)
                    }
                } else {
                    XCGLogger.default.debug("Unable to read results from backend.")
                }
            } else {
                XCGLogger.default.debug("Unable to load schedule from backend.")
            }
        }
    loadFavoritesData()
    }
    
    func load(callback: ((Schedule)->Void)?) {
        if loadFromUserDefaults() {
            if let cb = callback {
                cb(self)
            }
        } else {
            loadFromBackend(callback: callback)
        }
    }
    
    func getCurrentShow() ->Show? {
        return getShow(on: Date())
    }
    
    func getShow(on date: Date) -> Show? {
        let dt = TimePeriod.dateToWeekdayAndTime(date: date)
        for show in shows {
            if show.playingAtPeriod(date: dt) != nil {
                return show
            }
        }
        return nil
    }
    
    func getShow(onDayOfWeek: Int, atHour: Int) -> Show? {
        return getShow(on: TimePeriod.getDate(dayOfWeek: onDayOfWeek, hour: atHour))
    }
    
    func scheduleNotications() {
        for show in shows {
            if show.favorited {
                let notification = UILocalNotification()
                notification.fireDate = Date(timeIntervalSinceNow: 3)
                notification.alertBody = "\"\(show.name)\" is on air!"
                notification.soundName = UILocalNotificationDefaultSoundName
                UIApplication.shared.scheduleLocalNotification(notification)
            }
        }
    }
    
}
