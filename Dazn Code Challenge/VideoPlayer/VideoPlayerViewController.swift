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
    
    @IBOutlet var playerContainerView: UIView!
    @IBOutlet var currentTimeLabel: UILabel!
    
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
}

extension VideoPlayerViewController {
    
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
            self?.currentTimeLabel.text = "Current time: " + (self?.formatSecondsToString(time.seconds) ?? "")
        }
    }
    
    private func formatSecondsToString(_ seconds: TimeInterval) -> String {
        if seconds.isNaN {
            return "00:00"
        }
        let min = Int(seconds / 60)
        let sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", min, sec)
    }
    
    private func removePlayer() {
        playerLayer?.player?.pause()
        playerLayer?.player = nil
        playerCurrentTimeObserver = nil
        playerLayer?.removeFromSuperlayer()
    } 
    
    private func seek(by seconds: Double) {
        guard let player = playerLayer?.player, let duration = player.currentItem?.duration else { return }
        
        let playerCurrentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = playerCurrentTime + seconds
        if newTime < CMTimeGetSeconds(duration) {
            let time2: CMTime = CMTimeMake(value: Int64(newTime * 1000 as Float64), timescale: 1000)
            player.seek(to: time2)
        }
    }
    
    private func play() {
        playerLayer?.player?.play()
    }
    
    private func pause() {
        playerLayer?.player?.pause()
    }
    
    @IBAction func playAction(_ sender: Any) {
        play()
    }
    
    @IBAction func pauseAction(_ sender: Any) {
        pause()
    }
    
    @IBAction func seekToForward(_ sender: Any) {
        seek(by: 10)
    }
    
    @IBAction func seekToRewind(_ sender: Any) {
        seek(by: -10)
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        removePlayer()
        self.dismiss(animated: true, completion: nil)
    }
}
