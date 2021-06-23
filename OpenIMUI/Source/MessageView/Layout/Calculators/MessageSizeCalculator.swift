//
//  MessageSizeCalculator.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/8.
//

import UIKit

public struct NameHidden: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let incoming = NameHidden(rawValue: 0x01)
    public static let outgoing = NameHidden(rawValue: 0x02)
    public static let all: NameHidden = [.incoming, .outgoing]
    public static let none: NameHidden = []
}

open class MessageSizeCalculator: CellSizeCalculator {
    
    public var avatarSize: CGSize = CGSize(width: 42, height: 42)
    
    public var incomingNameLabelAlignment = LabelAlignment(textAlignment: .left,
                                                           textInsets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    public var outgoingNameLabelAlignment = LabelAlignment(textAlignment: .right,
                                                           textInsets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
    
    
    public var incomingMessageMargin = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    public var outgoingMessageMargin = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    
    public var incomingMessagePadding = UIEdgeInsets(top: 8.5, left: 19, bottom: 8.5, right: 9)
    public var outgoingMessagePadding = UIEdgeInsets(top: 8.5, left: 9, bottom: 8.5, right: 19)
    
    public var accessoryViewSize = CGSize(width: 34, height: 34)
    
    open override func configure(attributes: UICollectionViewLayoutAttributes) {
        guard let attributes = attributes as? MessagesCollectionViewLayoutAttributes else { return }
        
        let dataSource = messagesLayout.messagesDataSource
        let indexPath = attributes.indexPath
        let message = dataSource.messageForItem(at: indexPath, in: messagesLayout.messagesCollectionView)
        
        attributes.orientation = message.isSelf ? .outgoing : .incoming
        
        attributes.avatarSize = avatarSize(for: message, at: indexPath)
        
        switch attributes.orientation {
        case .incoming:
            attributes.nameLabelAlignment = incomingNameLabelAlignment
        case .outgoing:
            attributes.nameLabelAlignment = outgoingNameLabelAlignment
        }
        
        attributes.nameLabelIsHidden = nameIsHidden(for: message, at: indexPath)
        attributes.nameLabelSize = nameSize(for: message, at: indexPath)
        
        attributes.messageContainerMargin = messageContainerMargin(for: message, at: indexPath)
        attributes.messageContainerPadding = messageContainerPadding(for: message, at: indexPath)
        attributes.messageContainerSize = messageContainerSize(for: message, at: indexPath)
        
        attributes.accessoryViewSize = accessoryViewSize(for: message, at: indexPath)
    }
    
    open override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let dataSource = messagesLayout.messagesDataSource
        let message = dataSource.messageForItem(at: indexPath, in: messagesLayout.messagesCollectionView)
        let itemHeight = max(avatarSize.height, cellContentHeight(for: message, at: indexPath))
        
        return CGSize(width: messagesLayout.itemWidth, height: itemHeight)
    }

    open func cellContentHeight(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
        let nameLabelHeight = nameSize(for: message, at: indexPath).height
        let messageContainerHeight = messageContainerSize(for: message, at: indexPath).height
        let messageContainerMargin = messageContainerMargin(for: message, at: indexPath)
        
        return nameLabelHeight + messageContainerMargin.top + messageContainerHeight + messageContainerMargin.bottom
    }
    
    // MARK: - Name
    open func nameIsHidden(for message: MessageType, at indexPath: IndexPath) -> Bool {
        let layoutDelegate = messagesLayout.messagesLayoutDelegate
        let collectionView = messagesLayout.messagesCollectionView
        let isHidden = layoutDelegate.nameLabelIsHidden(for: message, at: indexPath, in: collectionView)
        return isHidden
    }
    
    open func nameSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let layoutDelegate = messagesLayout.messagesLayoutDelegate
        let collectionView = messagesLayout.messagesCollectionView
        let nameHeight = layoutDelegate.nameLabelHeight(for: message, at: indexPath, in: collectionView)
        let avatarWidth = avatarSize(for: message, at: indexPath).width
        
        let contentWidth = messagesLayout.itemWidth - avatarWidth * 2
        return CGSize(width: contentWidth, height: nameHeight)
    }
    
    // MARK: - Avatar

    open func avatarSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        return avatarSize
    }
    
    // MARK: - MessageContainer
    
    open func messageContainerMargin(for message: MessageType, at indexPath: IndexPath) -> UIEdgeInsets {
        return message.isSelf ? outgoingMessageMargin : incomingMessageMargin
    }

    open func messageContainerPadding(for message: MessageType, at indexPath: IndexPath) -> UIEdgeInsets {
        return message.isSelf ? outgoingMessagePadding : incomingMessagePadding
    }

    open func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        return .zero
    }

    open func messageContainerMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
        let avatarWidth = avatarSize(for: message, at: indexPath).width
        let messageContainerMargin = messageContainerMargin(for: message, at: indexPath)
        let messageContainerPadding = messageContainerPadding(for: message, at: indexPath)
        
        return messagesLayout.itemWidth - avatarWidth * 2 - messageContainerMargin.left - messageContainerMargin.right - messageContainerPadding.left - messageContainerPadding.right
    }
    
    // MARK: - Accessory View

    public func accessoryViewSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        return accessoryViewSize
    }
    
    
    // MARK: - Helpers

    internal func labelSize(for attributedText: NSAttributedString, considering maxWidth: CGFloat) -> CGSize {
        let constraintBox = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let rect = attributedText.boundingRect(with: constraintBox,
                                               options: [.usesLineFragmentOrigin, .usesFontLeading],
                                               context: nil)
            .integral

        return rect.size
    }
}
