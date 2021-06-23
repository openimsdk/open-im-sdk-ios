//
//  AudioMessageCell.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/20.
//

import UIKit

open class AudioMessageCell: MessageContentCell {
    
    lazy var animationView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        if let image = ImageCache.named("openim_icon_voice_playing_3") {
            imageView.image = image
            imageView.bounds.size = image.size
        }
        imageView.animationDuration = 0.5
        imageView.animationImages = (1...3).map{ ImageCache.named("openim_icon_voice_playing_\($0)")! }
        imageView.contentMode = .scaleToFill
        messageContainerView.addSubview(imageView)
        return imageView
    }()
    
    lazy var durationLabel: UILabel = {
        var label = UILabel()
        label.isUserInteractionEnabled = false
        label.numberOfLines = 1
        label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.bounds.size = CGSize(width: 30, height: 23)
        messageContainerView.addSubview(label)
        return label
    }()
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        animationView.stopAnimating()
        durationLabel.text = ""
    }
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes else {
            return
        }
        
        var origin = CGPoint.zero
        switch attributes.orientation {
        case .incoming:
            animationView.transform = CGAffineTransform(rotationAngle: 0)
            origin.x = attributes.messageContainerPadding.left
        case .outgoing:
            animationView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            origin.x = attributes.messageContainerSize.width - attributes.messageContainerPadding.right - animationView.bounds.width
        }
        origin.y = (attributes.messageContainerSize.height - animationView.bounds.height) * 0.5
        animationView.frame.origin = origin
        
        switch attributes.orientation {
        case .incoming:
            durationLabel.textAlignment = .left
            origin.x = animationView.frame.maxX
        case .outgoing:
            durationLabel.textAlignment = .right
            origin.x = animationView.frame.minX - durationLabel.bounds.size.width
        }
        durationLabel.frame.origin = origin
    }

    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        switch message.content {
        case .audio(let item):
            durationLabel.text = "\(item.duration)''"
        default:
            fatalError()
        }
        
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError()
        }
        
        durationLabel.textColor = displayDelegate.audioTipsColor(for: message, at: indexPath, in: messagesCollectionView)
        displayDelegate.configureAudioCell(self, message: message)
        
        testProgress(message: message)
    }
    
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: self)
        
        if messageContainerView.frame.contains(touchLocation) {
            delegate?.didTapPlayButton(in: self)
        } else {
            super.handleTapGesture(gesture)
        }
    }
    
}
