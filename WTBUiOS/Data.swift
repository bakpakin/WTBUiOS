//
//  Data.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 3/19/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation
import Kanna
import Alamofire
import SwiftyJSON
import SWXMLHash
import XCGLogger

var dataSchedule: [[String]]?
var dataShowList: [String]?

func dataGetSchedule(callback: ([[String]]?)->Void) {
    
    Alamofire.request(.GET, "http://www.wtburadio.org/programming/")
        .responseString{ response in
            if let source = response.result.value {
                if let doc = Kanna.HTML(html: source, encoding: NSUTF8StringEncoding) {
                    for item in doc.css("table.table-pro") {
                        var s: [[String]] = [[String]]()
                        if let text = item.text {
                            let blocks = text.componentsSeparatedByString("\n\n\n")
                            for block in blocks { // For each day of the week
                                var items = [String]()
                                let splitstring = block.componentsSeparatedByString("\n")
                                items.appendContentsOf(splitstring)
                                items.removeFirst()
                                if items.count > 0 {
                                    s.append(items)
                                }
                            }
                            s.removeFirst()
                            dataSchedule = s
                            break
                        }
                    }
                    log.debug("Finished parsing schedule website html.")
                    var showSet = Set<String>()
                    for x in dataSchedule! {
                        for y in x {
                            if y != "" {
                                showSet.insert(y)
                            }
                        }
                    }
                    dataShowList = []
                    for item in showSet {
                        dataShowList!.append(item)
                    }
                    log.debug("\(dataShowList!.count)")
                    callback(dataSchedule)
                } else {
                    log.debug("Unable to parse schedule site HTML.")
                }
            } else {
                log.debug("Source not found.")
            }
    }
}

func dataGetAlbumArt(artist: String, song: String, callback: (UIImage?)->Void) {
    
    Alamofire.request(.GET, "https://itunes.apple.com/search", parameters: ["term": "\(artist) \(song)", "limit": "1"])
        .responseJSON { response in
            if let jsonNative = response.result.value {
                // Convert to SwiftyJSON
                let json = JSON(jsonNative)
                let artworkURL : String = String(json["results"][0]["artworkUrl100"]).stringByReplacingOccurrencesOfString("/100x100", withString: "/1000x1000")
                if let url = NSURL(string: artworkURL) {
                    if let data = NSData(contentsOfURL: url) {
                        callback(UIImage(data: data))
                    }
                } else {
                    log.debug("Did not get coverart from itunes API.")
                }
            } else {
                log.debug("Did not get JSON from itunes API for cover art.")
            }
    }
    
}

func dataGetSongData(callback: (String, String)->Void) {
    
    Alamofire.request(.GET, "https://spinitron.com/radio/rss.php", parameters: ["station" : "wtbu"])
        .responseString { response in
            if let rssdata = response.result.value {
                let xml = SWXMLHash.parse(rssdata)
                var schedule = [[String:String]]()
                for item in xml["rss"]["channel"]["item"] {
                    let dateString: String = (item["pubDate"].element?.text)!
                    let itemMap = [
                        "title": (item["title"].element?.text)!,
                        "data": dateString
                    ]
                    schedule.append(itemMap)
                }
                let title = schedule[0]["title"]
                log.debug(title)
                let artistAndSongArray = title!.componentsSeparatedByString(": ")
                
                let artist = artistAndSongArray[0]
                let song = artistAndSongArray[1].stringByReplacingOccurrencesOfString("'", withString: "")
                
                callback(song, artist)
            }
    }
    
}
