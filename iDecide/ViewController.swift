//
//  ViewController.swift
//  iDecide
//
//  Created by Zach Eidenberger on 10/10/17.
//  Copyright © 2017 ZacharyG. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        playVideo()
    }
    
    func playVideo() {
        guard let path = Bundle.main.path(forResource: "getStarted", ofType: "mp4") else {
            print("Couldn't Find the Video")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }



}

