//
//  MessageReusableDateView.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/27.
//

import UIKit

open class MessageReusableDateView: MessageReusableView {
    
    open lazy var contentView: UIView = {
        let view = UIView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.frame = bounds
        addSubview(view)
        return view
    }()
    
    open lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.frame = contentView.bounds
        contentView.addSubview(label)
        return label
    }()
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = ""
    }
    
    open func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError()
        }
        
        dateLabel.font = displayDelegate.systemTextFont(for: message, at: indexPath, in: messagesCollectionView)
        dateLabel.textColor = displayDelegate.systemTextColor(for: message, at: indexPath, in: messagesCollectionView)
        
        dateLabel.text = OIMDateFormatter.shared.format(message.sendTime)
    }
}
