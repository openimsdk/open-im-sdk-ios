//
//  MessagesCollectionViewFlowLayout.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/8.
//

import UIKit
import OpenIM

public class MessagesCollectionViewFlowLayout: UICollectionViewFlowLayout {

    open override class var layoutAttributesClass: AnyClass {
        return MessagesCollectionViewLayoutAttributes.self
    }
    
    public var messagesCollectionView: MessagesCollectionView {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError()
        }
        return messagesCollectionView
    }
    
    public var messagesDataSource: MessagesDataSource {
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError()
        }
        return messagesDataSource
    }
    
    public var messagesLayoutDelegate: MessagesLayoutDelegate {
        guard let messagesLayoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
            fatalError()
        }
        return messagesLayoutDelegate
    }

    public var itemWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        return collectionView.frame.width - sectionInset.left - sectionInset.right
    }
    
    // MARK: - Initializers

    public override init() {
        super.init()
        setupView()
        setupObserver()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        setupObserver()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    
    private func setupView() {
        minimumLineSpacing = 10
        sectionInset = UIEdgeInsets(top: 4, left: 22, bottom: 4, right: 22)
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesCollectionViewFlowLayout.handleOrientationChange(_:)), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    // MARK: - Attributes

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesArray = super.layoutAttributesForElements(in: rect) as? [MessagesCollectionViewLayoutAttributes] else {
            return nil
        }
        for attributes in attributesArray where attributes.representedElementCategory == .cell {
            let cellSizeCalculator = cellSizeCalculatorForItem(at: attributes.indexPath)
            cellSizeCalculator.configure(attributes: attributes)
        }
        return attributesArray
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) as? MessagesCollectionViewLayoutAttributes else {
            return nil
        }
        if attributes.representedElementCategory == .cell {
            let cellSizeCalculator = cellSizeCalculatorForItem(at: attributes.indexPath)
            cellSizeCalculator.configure(attributes: attributes)
        }
        return attributes
    }
    
    // MARK: - Layout Invalidation

    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return collectionView?.bounds.width != newBounds.width
    }

    open override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        guard let flowLayoutContext = context as? UICollectionViewFlowLayoutInvalidationContext else { return context }
        flowLayoutContext.invalidateFlowLayoutDelegateMetrics = shouldInvalidateLayout(forBoundsChange: newBounds)
        return flowLayoutContext
    }

    @objc
    private func handleOrientationChange(_ notification: Notification) {
        invalidateLayout()
    }
    
    // MARK: - Cell Sizing
    lazy open var textMessageSizeCalculator = TextMessageSizeCalculator(layout: self)
    lazy open var mediaMessageSizeCalculator = MediaMessageSizeCalculator(layout: self)
    lazy open var audioMessageSizeCalculator = AudioMessageSizeCalculator(layout: self)
    lazy open var systemMessageSizeCalculator = SystemMessageSizeCalculator(layout: self)
    
    open func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        switch message.content {
        case .text, .unknown:
            return textMessageSizeCalculator
        case .image, .video:
            return mediaMessageSizeCalculator
        case .audio:
            return audioMessageSizeCalculator
        case .system(_, _):
            return systemMessageSizeCalculator
        }
    }
    
    open func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let calculator = cellSizeCalculatorForItem(at: indexPath)
        return calculator.sizeForItem(at: indexPath)
    }
    
    public func setMessageAvatarSize(_ newSize: CGSize) {
        messageSizeCalculators().forEach { $0.avatarSize = newSize }
    }
    
    public func setMessageIncomingMessageMargin(_ newPadding: UIEdgeInsets) {
        messageSizeCalculators().forEach { $0.incomingMessageMargin = newPadding }
    }
    
    public func setMessageOutgoingMessageMargin(_ newPadding: UIEdgeInsets) {
        messageSizeCalculators().forEach { $0.outgoingMessageMargin = newPadding }
    }
    
    
    public func setMessageIncomingMessagePadding(_ newPadding: UIEdgeInsets) {
        messageSizeCalculators().forEach { $0.incomingMessagePadding = newPadding }
    }
    
    public func setMessageOutgoingMessagePadding(_ newPadding: UIEdgeInsets) {
        messageSizeCalculators().forEach { $0.outgoingMessagePadding = newPadding }
    }
    
    open func messageSizeCalculators() -> [MessageSizeCalculator] {
        return [
            textMessageSizeCalculator,
            mediaMessageSizeCalculator,
            audioMessageSizeCalculator,
        ]
    }
}
