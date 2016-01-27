//
//  PlayerViewController.swift
//  WTBUiOS
//
//  Created by Ben Cootner on 1/27/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    @IBOutlet weak var miniButtonPlay: UIButton!
     @IBOutlet weak var buttonPlay: UIButton!
     @IBOutlet weak var sliderVolume: UISlider!
     @IBOutlet weak var imageCoverArt: UIImageView!
    
    
    override func viewWillAppear(animated: Bool) {
       
        self.view.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 50, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) + 50)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonPlay.setTitle("Play", forState: UIControlState.Normal)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func playButtonClicked(sender: AnyObject) {
            toggle()
        }
    
    
        @IBAction func sliderValueChanged(sender: AnyObject) {
    
            RadioPlayer.sharedInstance.volume(sliderVolume.value)
    
        }
    
        func toggle() {
            if RadioPlayer.sharedInstance.currentlyPlaying() {
                pauseRadio()
            } else {
                playRadio()
            }
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
