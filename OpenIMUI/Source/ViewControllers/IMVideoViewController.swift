//
//  IMVideoViewController.swift
//  OpenIMUI
//
//  Created by Snow on 2021/6/21.
//

import UIKit
import MediaPlayer;
import AVFoundation;
import AVKit;

open class IMVideoViewController: IMMediaViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        let vc = AVPlayerViewController()
        addChild(vc)
        vc.view.frame = view.frame
        view.addSubview(vc.view)
        
        vc.player = AVPlayer(url: url)
        vc.player?.play()
    }

}

