//
//  ImageMessageCell.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/20.
//

import UIKit

public class ImageMessageCell: MessageContentCell {
    
    open lazy var imageView: MessageImageView = {
        let imageView = MessageImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        messageContainerView.addSubview(imageView)
        return imageView
    }()
    
    public override func setupSubviews() {
        super.setupSubviews()
        
        messageContainerView.layer.cornerRadius = 5
        messageContainerView.backgroundColor = UIColor(red: 0.94, green: 0.94, blue: 0.94, alpha: 1)
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        progressView.isHidden = true
    }
    
    public override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        imageView.frame = messageContainerView.bounds
    }
    
    public override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        messageContainerView.image = nil
        if case let .image(item) = message.content {
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
        delegate?.didTapImage(in: self)
    }
}
