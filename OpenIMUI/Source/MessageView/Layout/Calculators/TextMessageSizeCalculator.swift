//
//  TextMessageSizeCalculator.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/8.
//

import UIKit

open class TextMessageSizeCalculator: MessageSizeCalculator {

    public var messageLabelFont = UIFont.systemFont(ofSize: 14)
    
    open override func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let maxWidth = messageContainerMaxWidth(for: message, at: indexPath)

        var messageContainerSize: CGSize

        let text: String
        switch message.content {
        case .text(let str):
            text = str
        case .unknown:
            text = LocalizedString(message.content.description)
        default:
            fatalError("messageContainerSize received unhandled MessageDataType: \(message.content)")
        }
        
        let attributedText = NSAttributedString(string: text, attributes: [.font: messageLabelFont])
        messageContainerSize = labelSize(for: attributedText, considering: maxWidth)

        let messageContainerPadding = messageContainerPadding(for: message, at: indexPath)
        messageContainerSize.width += messageContainerPadding.left + messageContainerPadding.right
        messageContainerSize.height += messageContainerPadding.top + messageContainerPadding.bottom

        return messageContainerSize
    }

    open override func configure(attributes: UICollectionViewLayoutAttributes) {
        super.configure(attributes: attributes)
        guard let attributes = attributes as? MessagesCollectionViewLayoutAttributes else { return }
        attributes.messageLabelFont = messageLabelFont
    }
    
}
