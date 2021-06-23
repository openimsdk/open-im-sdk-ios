//
//  TextMessageCell.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/8.
//

import UIKit

open class TextMessageCell: MessageContentCell {
    
    open override weak var delegate: MessageCellDelegate? {
        didSet {
            messageLabel.delegate = delegate
        }
    }
    
    open var messageLabel = MessageLabel()
    
    // MARK: - Methods

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes {
            messageLabel.font = attributes.messageLabelFont
            messageLabel.textInsets = attributes.messageContainerPadding
            messageLabel.messageLabelFont = attributes.messageLabelFont
            messageLabel.frame = messageContainerView.bounds
        }
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.attributedText = nil
        messageLabel.text = nil
    }

    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(messageLabel)
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)

        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError()
        }
        
        nameLabel.textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)

        switch message.content {
        case .text(let text):
            let enabledDetectors = displayDelegate.enabledDetectors(for: message, at: indexPath, in: messagesCollectionView)

            messageLabel.configure {
                messageLabel.enabledDetectors = enabledDetectors
                for detector in enabledDetectors {
                    let attributes = displayDelegate.detectorAttributes(for: detector, and: message, at: indexPath)
                    messageLabel.setAttributes(attributes, detector: detector)
                }
                
                let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
                messageLabel.text = text
                messageLabel.textColor = textColor
            }
        case .unknown:
            messageLabel.text = LocalizedString(message.content.description)
        default:
            fatalError()
        }

    }
    
    open override func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        return messageLabel.handleGesture(touchPoint)
    }
    
}
