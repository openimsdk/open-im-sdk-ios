//
//  VideoMessageCell.swift
//  OpenIMUI
//
//  Created by Snow on 2021/6/16.
//

import UIKit

public class VideoMessageCell: ImageMessageCell {
    
    public override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        if case let .video(item) = message.content {
            imageView.setImage(with: item.thumbnail)
            testProgress(message: message)
        }
    }
    
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: messageContainerView)

        guard imageView.frame.contains(touchLocation) else {
            super.handleTapGesture(gesture)
            return
        }
        delegate?.didTapPlayButton(in: self)
    }
    
}
