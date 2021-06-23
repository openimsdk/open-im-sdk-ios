//
//  MessageCellDelegate.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/8.
//

import Foundation

public protocol MessageCellDelegate: MessageLabelDelegate {
    
    func didTapBackground(in cell: MessageCollectionViewCell)
    
    func didTapName(in cell: MessageCollectionViewCell)
    
    func didTapAvatar(in cell: MessageCollectionViewCell)
    
    func didTapMessage(in cell: MessageCollectionViewCell)
    
    func didTapAccessoryView(in cell: MessageCollectionViewCell)
    
    func didTapImage(in cell: MessageCollectionViewCell)
    
    func didTapPlayButton(in cell: AudioMessageCell)
    
    func didStartAudio(in cell: AudioMessageCell)
    
    func didStopAudio(in cell: AudioMessageCell)
    
    func didTapPlayButton(in cell: VideoMessageCell)
    
}

public extension MessageCellDelegate {
    
    func didTapBackground(in cell: MessageCollectionViewCell) {
        
    }
    
    func didTapName(in cell: MessageCollectionViewCell) {
        
    }
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        
    }
    
    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        
    }
    
    func didStartAudio(in cell: AudioMessageCell) {
        
    }
    
    func didStopAudio(in cell: AudioMessageCell) {
        
    }
}
