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

class PlayerViewController: AllViewController {

    @IBOutlet weak var songArtistLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var imageCoverArt: UIImageView!
    
    var timer: NSTimer = NSTimer()
    
    func getCurrentSongData() {
        getSongData()
    }
    
    func setAlbumImage(image: UIImage!) {
        imageCoverArt.image = image
        imageCoverArt.layer.cornerRadius = imageCoverArt.frame.width / 2
        imageCoverArt.layer.masksToBounds = true
        imageCoverArt.clipsToBounds = true
        imageCoverArt.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
        imageCoverArt.layer.borderWidth = 5
    }
    
    func getSongData(songID: Int? = nil) {
        var parameters = [String : AnyObject]()
        if let id = songID {
            parameters["SongID"] = id
        }
        let defaultImage = "Cover"
        Alamofire.request(.GET, "https://gaiwtbubackend.herokuapp.com/song", parameters: parameters).responseJSON {
            response in
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
                    if let url = NSURL(string: albumArtUrl) {
                        if let data = NSData(contentsOfURL: url) {
                            self.setAlbumImage(UIImage(data: data))
                        } else {
                            self.setAlbumImage(UIImage(named: defaultImage))
                            log.debug("Could not get image data from album art url.")
                        }
                    } else {
                        self.setAlbumImage(UIImage(named: defaultImage))
                        log.debug("Could not read album art url.")
                    }
                } else {
                   self.setAlbumImage(UIImage(named: defaultImage))
                    log.debug("No album art url.")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        setAlbumImage(imageCoverArt.image!)
        getCurrentSongData()
        timer = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: #selector(PlayerViewController.getCurrentSongData), userInfo: nil, repeats: true)
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
