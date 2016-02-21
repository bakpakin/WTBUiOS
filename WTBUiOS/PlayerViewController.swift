//
//  PlayerViewController.swift
//  WTBUiOS
//
//  Created by Ben Cootner on 1/27/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SWXMLHash
import XCGLogger

class PlayerViewController: UIViewController {

    @IBOutlet weak var songArtistLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var imageCoverArt: UIImageView!
    
    var timer: NSTimer = NSTimer()
    
    // Downloads and displays the album art for a given song from the itunes API
    private func getAlbumArt(artist: String, song: String) {
        
        Alamofire.request(.GET, "https://itunes.apple.com/search", parameters: ["term": "\(artist) \(song)", "limit": "1"])
            .responseJSON { response in
                if let jsonNative = response.result.value {
                    // Convert to SwiftyJSON
                    let json = JSON(jsonNative)
                    let artworkURL : String = String(json["results"][0]["artworkUrl100"]).stringByReplacingOccurrencesOfString("/100x100", withString: "/1000x1000")
                    if let url = NSURL(string: artworkURL) {
                        if let data = NSData(contentsOfURL: url) {
                            self.imageCoverArt.image = UIImage(data: data)
                        }
                    } else {
                        log.debug("Did not get coverart from itunes API.")
                    }
                } else {
                    log.debug("Did not get JSON from itunes API for cover art.")
                }
        }
        
    }
    
    // Gets the current schedule from Spinitron and current song.
    func getSongData() {
        
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
                    
                    self.getAlbumArt(artist, song: song)
                    self.songTitleLabel.text = song
                    self.songArtistLabel.text = artist
                }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCoverArt.layer.cornerRadius = imageCoverArt.bounds.width / 2 + 10
        imageCoverArt.layer.masksToBounds = true
        imageCoverArt.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
        imageCoverArt.layer.borderWidth = 5
        getSongData()
        timer = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: "getSongData", userInfo: nil, repeats: true)
        playRadio()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playButtonClicked(sender: AnyObject) {
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            pauseRadio()
        } else {
            playRadio()
        }
    }

    func playRadio() {
        RadioPlayer.sharedInstance.play()
        buttonPlay.setImage(UIImage(named: "pause.png"), forState: UIControlState.Normal)
    }

    func pauseRadio() {
        RadioPlayer.sharedInstance.pause()
        buttonPlay.setImage(UIImage(named: "play.png"), forState: UIControlState.Normal)
    }

}
