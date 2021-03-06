//
//  RadioPlayer.swift
//  WTBUiOS
//
//  Created by Ben Cootner on 1/26/16.
//  Copyright © 2016 Calvin Rose. All rights reserved.
//

import Foundation
import AVFoundation
import XCGLogger

class RadioPlayer {
    
    static let sharedInstance = RadioPlayer()
    private var player = AVPlayer(url: URL(string: "http://wtbu.bu.edu:1800/listen.m3u")!)
    private var isPlaying = false
    
    // Ensure proper background playing
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
            XCGLogger.default.debug("Failed setting up AVAudioSession category.")
        }
    }
    
    func play() {
        player.play()
        isPlaying = true
    }
    
    func pause() {
        player.pause()
        isPlaying = false
    }
    
    func volume(value:Float){
        player.volume = value
    }
    
    func toggle() {
        if isPlaying == true {
            pause()
        } else {
            play()
        }
    }
    
    func currentlyPlaying() -> Bool {
        return isPlaying
    }
    
}
