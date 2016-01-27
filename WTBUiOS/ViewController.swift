//
//  ViewController.swift
//  WTBUiOS
//
//  Created by Calvin Rose on 1/26/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var sliderVolume: UISlider!
    @IBOutlet weak var imageCoverArt: UIImageView!
    
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
    }
    
    func pauseRadio() {
        RadioPlayer.sharedInstance.pause()
        buttonPlay.setTitle("Play", forState: UIControlState.Normal)
        
    }
    
}