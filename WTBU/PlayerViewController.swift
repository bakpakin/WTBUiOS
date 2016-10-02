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
import XCGLogger

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var showTitleLabel: UILabel!
    @IBOutlet weak var songArtistLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var imageCoverArt: UIImageView!
    
    var timer: Timer = Timer()
    
    func getCurrentSongData() {
        let show = Schedule.defaultSchedule.getShow(on: Date())
        showTitleLabel.text = show?.name
        getSongData()
    }
    
    func getSongData(songID: Int? = nil) {
        var parameters = [String : AnyObject]()
        if let id = songID {
            parameters["SongID"] = id as AnyObject?
        }
        let defaultImage = "Cover"
        Alamofire.request("https://gaiwtbubackend.herokuapp.com/song", parameters: parameters).responseJSON { response in
            if let nativeJson = response.result.value {
                let json = JSON(nativeJson)
                let results = json["results"]
                let artist = results["ArtistName"].string ?? "No Artist Information"
                let song = results["SongName"].string ?? "No Song Information"
                self.songTitleLabel.text = song
                self.songArtistLabel.text = artist
                Schedule.defaultSchedule.load() {
                    schedule in
                    if let showName = schedule.getCurrentShow()?.name {
                        self.navigationItem.title = showName
                    } else {
                        self.navigationItem.title = "Radio"
                    }
                }
                if let albumArtUrl = results["AlbumArt"]["1000x1000"].string {
                    self.imageCoverArt.downloadedFrom(link: albumArtUrl)
                } else {
                    self.imageCoverArt.image = UIImage(named: defaultImage)
                    XCGLogger.default.debug("No album art url.")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentSongData()
        timer = Timer.scheduledTimer(timeInterval: 15.0, target: self, selector: #selector(PlayerViewController.getCurrentSongData), userInfo: nil, repeats: true)
        playRadio()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playButtonClicked(sender: AnyObject) {
        XCGLogger.default.debug("play button clicked!")
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            pauseRadio()
        } else {
            playRadio()
        }
    }
    
    func playRadio() {
        RadioPlayer.sharedInstance.play()
        buttonPlay.setImage(UIImage(named: "pause.png"), for: UIControlState.normal)
    }
    
    func pauseRadio() {
        RadioPlayer.sharedInstance.pause()
        buttonPlay.setImage(UIImage(named: "play.png"), for: UIControlState.normal)
    }
    
}
