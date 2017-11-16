//
//  LaunchScreenAVPlayerViewController.swift
//  iDecide
//
//  Created by Zach Eidenberger on 11/2/17.
//  Copyright © 2017 ZacharyG. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class LaunchScreenViewController: UIViewController, AVPlayerViewControllerDelegate {
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    var playerDidPlay = false
    override func viewDidLoad() {
        playerViewController.delegate = self
        let when = DispatchTime.now() + 7
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.playerViewController.dismiss(animated: true) {
                self.playerViewController.player?.pause()
                self.performSegue(withIdentifier: "getStarted", sender: self)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let videoURL = Bundle.main.url(forResource: "GetStarted", withExtension: ".mp4")
        playerView = AVPlayer(url: videoURL! as URL)
        playerViewController.videoGravity = AVLayerVideoGravityResizeAspect
        playerViewController.view.backgroundColor = UIColor.white
        playerViewController.player = playerView
        playerViewController.showsPlaybackControls = false
        playerViewController.player?.rate = 1.5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.playerDidPlay == false {
            self.present(playerViewController, animated: false) {
                self.playerDidPlay = true
            }
        }else{
            performSegue(withIdentifier: "getStarted", sender: self)
            
        }
        self.playerViewController.player?.play()
        
    }
    
    
}
