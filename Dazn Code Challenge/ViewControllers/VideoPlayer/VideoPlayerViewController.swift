//
//  VideoPlayerViewController.swift
//  Dazn Code Challenge
//
//  Created by Piotr Krzesaj on 16/09/2019.
//  Copyright © 2019 dazn. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerViewController: UIViewController {
    
    private var playerLayer: AVPlayerLayer?
    private var playerCurrentTimeObserver: Any?
    
    @IBOutlet weak var playerContainerView: UIView!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    var model: URL? {
        didSet {
            guard isViewLoaded else { return }
            updatePlayer()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePlayer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removePlayer()
        
    }
    
    private func updatePlayer() {
        guard let url = model else {
            removePlayer()
            return
        }
        if playerLayer == nil {
            addPlayer(url)
        } else {
            let playerItem = AVPlayerItem(url: url)
            playerLayer?.player?.replaceCurrentItem(with: playerItem)
            playerLayer?.player?.play()
        }
    }
    
    private func addPlayer(_ url: URL) {
        guard playerLayer == nil else { return }
        
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerContainerView.layer.addSublayer(playerLayer)
        self.playerLayer = playerLayer
        
        playerLayer.frame = playerContainerView.bounds
        addPlayerObservers(player)
        
        player.play()
    }
    
    private func addPlayerObservers(_ player: AVPlayer) {
        playerCurrentTimeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds:1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main) { [weak self] time in
            self?.currentTimeLabel.text = self?.formatSecondsToString(time.seconds)
        }
    }
    
    private func formatSecondsToString(_ seconds: TimeInterval) -> String {
        if seconds.isNaN {
            return "00:00"
        }
        let Min = Int(seconds / 60)
        let Sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", Min, Sec)
    }
    
    private func removePlayer() {
        playerLayer?.player?.pause()
        playerLayer?.player = nil
        playerCurrentTimeObserver = nil
        playerLayer?.removeFromSuperlayer()
    }
    
    @IBAction func playAction(_ sender: Any) {
        playerLayer?.player?.play()
    }
    
    @IBAction func pauseAction(_ sender: Any) {
        playerLayer?.player?.pause()
    }
}
