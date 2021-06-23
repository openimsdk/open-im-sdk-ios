//
//  MessageContentCell.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/8.
//

import UIKit

open class MessageContentCell: MessageCollectionViewCell {
    
    open var avatarView: MessageImageView = {
        let avatarView = MessageImageView()
        avatarView.clipsToBounds = true
        avatarView.layer.masksToBounds = true
        return avatarView
    }()
    
    open var nameLabel: InsetLabel = InsetLabel()
    
    open var messageContainerView: MessageContainerView = {
        let containerView = MessageContainerView()
        containerView.clipsToBounds = true
        containerView.layer.masksToBounds = true
        return containerView
    }()
    
    open var accessoryView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    open lazy var progressView: ProgressView = {
        let progressView = ProgressView()
        progressView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        messageContainerView.addSubview(progressView)
        return progressView
    }()
    
    open weak var delegate: MessageCellDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    open func setupSubviews() {
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageContainerView)
        contentView.addSubview(accessoryView)
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.image = nil
        nameLabel.attributedText = nil
        accessoryView.image = nil
        progressView.isHidden = true
    }
    
    // MARK: - Configuration
    
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes else { return }
        layoutAvatarView(with: attributes)
        layoutNameLabel(with: attributes)
        layoutMessageContainerView(with: attributes)
        layoutAccessoryView(with: attributes)
    }
    
    open override func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            fatalError()
        }
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError()
        }
        
        delegate = messagesCollectionView.messageCellDelegate
        
        displayDelegate.configureAvatarView(avatarView, for: message, at: indexPath, in: messagesCollectionView)
        
        if !nameLabel.isHidden {
            nameLabel.attributedText = dataSource.nameLabelAttributedText(for: message, at: indexPath, in: messagesCollectionView)
        }
        
        messageContainerView.image = displayDelegate.bubbleImage(for: message, at: indexPath, in: messagesCollectionView)
        
        displayDelegate.configureAccessoryView(accessoryView, for: message, at: indexPath, in: messagesCollectionView)
    }
    
    open override func handleTapGesture(_ gesture: UIGestureRecognizer) {
        let touchLocation = gesture.location(in: self)
        
        switch true {
        case messageContainerView.frame.contains(touchLocation)
                && !cellContentView(canHandle: convert(touchLocation, to: messageContainerView)):
            delegate?.didTapMessage(in: self)
        case avatarView.frame.contains(touchLocation):
            delegate?.didTapAvatar(in: self)
        case nameLabel.frame.contains(touchLocation):
            delegate?.didTapName(in: self)
        case accessoryView.frame.contains(touchLocation):
            delegate?.didTapAccessoryView(in: self)
        default:
            delegate?.didTapBackground(in: self)
        }
    }
    
    open override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let touchPoint = gestureRecognizer.location(in: self)
        guard gestureRecognizer.isKind(of: UILongPressGestureRecognizer.self) else { return false }
        return messageContainerView.frame.contains(touchPoint)
    }

    open func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        return false
    }
    
    // MARK: - Origin Calculations
    
    open func layoutAvatarView(with attributes: MessagesCollectionViewLayoutAttributes) {
        var origin: CGPoint = .zero
        
        switch attributes.orientation {
        case .incoming:
            origin = .zero
        case .outgoing:
            origin.x = bounds.width - attributes.avatarSize.width
        }
        
        avatarView.frame = CGRect(origin: origin, size: attributes.avatarSize)
    }
    
    open func layoutNameLabel(with attributes: MessagesCollectionViewLayoutAttributes) {
        nameLabel.isHidden = attributes.nameLabelIsHidden
        
        nameLabel.textAlignment = attributes.nameLabelAlignment.textAlignment
        nameLabel.textInsets = attributes.nameLabelAlignment.textInsets
        
        let origin: CGPoint = CGPoint(x: avatarView.bounds.maxX + attributes.messageContainerMargin.left, y: 0)
        nameLabel.frame = CGRect(origin: origin, size: attributes.nameLabelSize)
    }
    
    open func layoutMessageContainerView(with attributes: MessagesCollectionViewLayoutAttributes) {
        let offsetY = nameLabel.bounds.maxY + attributes.messageContainerMargin.top
        var origin: CGPoint = CGPoint(x: 0, y: offsetY)
        
        switch attributes.orientation {
        case .incoming:
            origin.x = avatarView.frame.maxX + attributes.messageContainerMargin.left
        case .outgoing:
            origin.x = avatarView.frame.minX - attributes.messageContainerMargin.right - attributes.messageContainerSize.width
        }
        
        messageContainerView.frame = CGRect(origin: origin, size: attributes.messageContainerSize)
    }
    
    open func layoutAccessoryView(with attributes: MessagesCollectionViewLayoutAttributes) {
        let y = messageContainerView.frame.midY - attributes.accessoryViewSize.height * 0.5
        
        var origin: CGPoint = CGPoint(x: 0, y: y)
        
        switch attributes.orientation {
        case .incoming:
            origin.x = messageContainerView.frame.maxX
        case .outgoing:
            origin.x = messageContainerView.frame.minX - attributes.accessoryViewSize.width
        }
        
        accessoryView.frame = CGRect(origin: origin, size: attributes.accessoryViewSize)
    }
    
    public func testProgress(message: MessageType) {
        if message.isSelf, message.status == .none {
            progressView.isHidden = false
            progressView.frame = messageContainerView.bounds
            progressView.msgID = message.messageId
        }
    }
    
}
