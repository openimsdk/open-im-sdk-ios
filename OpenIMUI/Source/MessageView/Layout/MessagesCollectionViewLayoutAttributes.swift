//
//  MessagesCollectionViewLayoutAttributes.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/8.
//

import UIKit

open class MessagesCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    
    public enum Orientation {
        case incoming
        case outgoing
    }
    
    public var orientation = Orientation.outgoing
    
    public var avatarSize: CGSize = .zero
    
    public var nameLabelIsHidden = false
    public var nameLabelAlignment = LabelAlignment(textAlignment: .center, textInsets: .zero)
    public var nameLabelSize: CGSize = .zero
    
    public var messageContainerSize: CGSize = .zero
    // 外边距
    public var messageContainerMargin: UIEdgeInsets = .zero
    // 内边距
    public var messageContainerPadding: UIEdgeInsets = .zero
    
    public var messageLabelFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    
    public var accessoryViewSize: CGSize = .zero

    // MARK: - Methods

    open override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! MessagesCollectionViewLayoutAttributes
        copy.orientation = orientation
        
        copy.avatarSize = avatarSize
        
        copy.nameLabelIsHidden = nameLabelIsHidden
        copy.nameLabelAlignment = nameLabelAlignment
        copy.nameLabelSize = nameLabelSize
        
        copy.messageContainerSize = messageContainerSize
        copy.messageContainerMargin = messageContainerMargin
        copy.messageContainerPadding = messageContainerPadding
        copy.messageLabelFont = messageLabelFont
        
        copy.accessoryViewSize = accessoryViewSize
        
        return copy
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        guard let attributes = object as? MessagesCollectionViewLayoutAttributes else { return false }
        
        return super.isEqual(attributes)
            && attributes.orientation == orientation
            
            && attributes.avatarSize == avatarSize
        
            && attributes.nameLabelIsHidden == nameLabelIsHidden
            && attributes.nameLabelAlignment == nameLabelAlignment
            && attributes.nameLabelSize == nameLabelSize
        
            && attributes.messageContainerSize == messageContainerSize
            && attributes.messageContainerMargin == messageContainerMargin
            && attributes.messageContainerPadding == messageContainerPadding
            && attributes.messageLabelFont == messageLabelFont
        
            && attributes.accessoryViewSize == accessoryViewSize
    }
}
