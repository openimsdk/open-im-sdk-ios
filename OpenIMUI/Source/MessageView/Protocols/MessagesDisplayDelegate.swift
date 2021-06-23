//
//  MessagesDisplayDelegate.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/8.
//

import UIKit

public protocol MessagesDisplayDelegate: AnyObject {
    
    func messageHeaderView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView
    
    func messageFooterView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView
    
    // MARK: - Cell
    
    func configureAvatarView(_ avatarView: MessageImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView)
    
    func configureAccessoryView(_ accessoryView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView)
    
    func bubbleImage(for message: MessageType, at  indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIImage?
    
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType]
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any]
    
    // MARK: - Audio Message
    
    func configureAudioCell(_ cell: AudioMessageCell, message: MessageType)
    
    func audioTipsColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor
    
    // MARK: - System Message
    
    func systemTextColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor
    
    func systemTextFont(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIFont
}

public extension MessagesDisplayDelegate {
    
    func configureAccessoryView(_ accessoryView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
    }
    
    func bubbleImage(for message: MessageType, at  indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIImage? {
        return message.isSelf
            ? ImageCache.named("openim_icon_sender", withCapInsets: UIEdgeInsets(top: 25, left: 6, bottom: 9, right: 15))
            : ImageCache.named("openim_icon_receiver", withCapInsets: UIEdgeInsets(top: 25, left: 15, bottom: 9, right: 6))
    }
    
    func messageHeaderView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView {
        fatalError()
    }

    func messageFooterView(for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageReusableView {
        fatalError()
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return []
    }

    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        return MessageLabel.defaultAttributes
    }
    
    func audioTipsColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    }
    
    
    func systemTextColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return UIColor(red: 0.686, green: 0.686, blue: 0.686, alpha: 1)
    }
    
    func systemTextFont(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIFont {
        return UIFont.systemFont(ofSize: 12)
    }
    
}
