//
//  BasicAudioController.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/24.
//

import UIKit
import AVFoundation

public enum PlayerState {
    case playing
    case stopped
}

open class BasicAudioController: NSObject, AVAudioPlayerDelegate {
    
    open var audioPlayer: AVAudioPlayer?
    open weak var playingCell: AudioMessageCell?
    
    open var playingMessage: MessageType?
    
    open private(set) var state: PlayerState = .stopped
    
    public weak var messageCollectionView: MessagesCollectionView?
    
    public init(messageCollectionView: MessagesCollectionView) {
        super.init()
        self.messageCollectionView = messageCollectionView
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(proximityStateDidChange),
                                               name: UIDevice.proximityStateDidChangeNotification,
                                               object: nil)
    }
    
    @objc
    func proximityStateDidChange() {
        if self.audioPlayer != nil {
            if UIDevice.current.proximityState {
                try? AVAudioSession.sharedInstance().setCategory(.playAndRecord)
            } else {
                try? AVAudioSession.sharedInstance().setCategory(.playback)
            }
        }
    }
    
    open func configureAudioCell(_ cell: AudioMessageCell, message: MessageType) {
        if playingMessage?.messageId == message.messageId, messageCollectionView != nil , audioPlayer != nil {
            playingCell = cell
            if state == .playing {
                cell.animationView.startAnimating()
            }
        }
    }
    
    open func playOrStopSound(for message: MessageType, in audioCell: AudioMessageCell) {
        if playingMessage?.messageId == message.messageId {
            if state == .playing {
                stopSound()
            } else {
                playSound(for: message, in: audioCell)
            }
        } else {
            stopSound()
            playSound(for: message, in: audioCell)
        }
    }
    
    open func playSound(for message: MessageType, in audioCell: AudioMessageCell) {
        switch message.content {
        case .audio(let item):
            do {
                guard let url = item.url else {
                    return
                }
                
                let data = try Data(contentsOf: url)
                let player = try AVAudioPlayer(data: data, fileTypeHint: AVFileType.wav.rawValue)
                
                playingCell = audioCell
                playingMessage = message
                audioPlayer = player
                audioPlayer?.prepareToPlay()
                audioPlayer?.delegate = self
                audioPlayer?.play()
                state = .playing
                audioCell.animationView.startAnimating()
                UIDevice.current.isProximityMonitoringEnabled = true
                proximityStateDidChange()
            } catch {
                
            }
        default:
            print("BasicAudioPlayer failed play sound becasue given message kind is not Audio")
        }
    }
    
    open func stopSound() {
        guard let player = audioPlayer else { return }
        
        UIDevice.current.isProximityMonitoringEnabled = false
        
        player.stop()
        state = .stopped
        if let cell = playingCell {
            cell.delegate?.didStopAudio(in: cell)
            
            cell.animationView.stopAnimating()
        }
        audioPlayer = nil
        playingCell = nil
    }
    
    // MARK: - AVAudioPlayerDelegate
    
    open func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopSound()
    }
}
