//
//  SystemMessageCell.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/27.
//

import UIKit

public class SystemMessageCell: MessageCollectionViewCell {
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.frame = bounds
        addSubview(view)
        return view
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.frame = containerView.bounds
        containerView.addSubview(label)
        return label
    }()
    
    public override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError()
        }
        
        textLabel.font = displayDelegate.systemTextFont(for: message, at: indexPath, in: messagesCollectionView)
        textLabel.textColor = displayDelegate.systemTextColor(for: message, at: indexPath, in: messagesCollectionView)
        
        switch message.content {
        case .system(_, let item):
            textLabel.text = item.defaultTips
        default:
            fatalError()
        }
    }
    
}
