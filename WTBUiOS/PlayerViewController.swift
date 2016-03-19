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

class PlayerViewController: AllViewController {

    @IBOutlet weak var songArtistLabel: UILabel!
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var imageCoverArt: UIImageView!
    
    var timer: NSTimer = NSTimer()
    
    func getSongData() {
        dataGetSongData({(artist, song) in
            self.songArtistLabel.text! = artist
            self.songTitleLabel.text! = song
            dataGetAlbumArt(artist, song: song, callback: { image in
                self.imageCoverArt.image = image
            })
        })
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
