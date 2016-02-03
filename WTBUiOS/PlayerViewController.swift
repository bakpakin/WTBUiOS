//
//  PlayerViewController.swift
//  WTBUiOS
//
//  Created by Ben Cootner on 1/27/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import SWXMLHash
import XCGLogger

class PlayerViewController: UIViewController {

    @IBOutlet weak var miniButtonPlay: UIButton!
     @IBOutlet weak var buttonPlay: UIButton!
     @IBOutlet weak var sliderVolume: UISlider!
     @IBOutlet weak var imageCoverArt: UIImageView!
    
    
    override func viewWillAppear(animated: Bool) {
       
        self.view.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 50, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) + 50)
    }
    
    // Downloads and displays the album art for a given song from the itunes API
    private func getAlbumArt(artist: String, song: String) {
        
        Alamofire.request(.GET, "https://itunes.apple.com/search", parameters: ["term": "\(artist) \(song)", "limit": "1"])
            .responseJSON { response in
                if let jsonNative = response.result.value {
                    
                    // Convert to SwiftyJSON
                    let json = JSON(jsonNative)
                    let artworkURL : String = String(json["results"][0]["artworkUrl100"]).stringByReplacingOccurrencesOfString("/100x100", withString: "/1024x1024")
                    
                    if let url = NSURL(string: artworkURL) {
                        if let data = NSData(contentsOfURL: url) {
                            self.imageCoverArt.image = UIImage(data: data)
                        }
                    }
                } else {
                    log.debug("Did not get JSON from itunes API for cover art.")
                }
        }
        
    }
    
    // Gets the current schedule from Spinitron and current song.
    private func getSongData() {
        
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
                    self.getAlbumArt(artistAndSongArray[0], song: artistAndSongArray[1])
                }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonPlay.setTitle("Play", forState: UIControlState.Normal)
        getSongData()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playButtonClicked(sender: AnyObject) {
        RadioPlayer.sharedInstance.toggle()
    }
    
    
    @IBAction func sliderValueChanged(sender: AnyObject) {
        RadioPlayer.sharedInstance.volume(sliderVolume.value)
    }

    func playRadio() {
        RadioPlayer.sharedInstance.play()
        buttonPlay.setTitle("Pause", forState: UIControlState.Normal)
        miniButtonPlay.setTitle("Pause", forState: UIControlState.Normal)
    }

    func pauseRadio() {
        RadioPlayer.sharedInstance.pause()
        buttonPlay.setTitle("Play", forState: UIControlState.Normal)
        miniButtonPlay.setTitle("Play", forState: UIControlState.Normal)
        
    }

}
