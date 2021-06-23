//
//  IMMessageViewController.swift
//  MessageKit
//
//  Created by Snow on 2021/6/7.
//

import UIKit


public protocol IMMessageViewControllerDelegate: AnyObject {
    func messageViewController(_ messageViewController: IMMessageViewController, loadMore completeHandler: @escaping (_ hasMore: Bool) -> Void)
    func messageViewController(_ messageViewController: IMMessageViewController, showMenuForItemAt cell: MessageCollectionViewCell, message: MessageType)
}

open class IMMessageViewController: UIViewController {
    
    public weak var delegate: IMMessageViewControllerDelegate?
    
    open private(set) lazy var collectionView: MessagesCollectionView = {
        let collectionView = MessagesCollectionView()
        collectionView.scrollsToTop = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.keyboardDismissMode = .interactive
        collectionView.alwaysBounceVertical = true
        collectionView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 13.0, *) {
            collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    public private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
        return control
    }()

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.autoresizingMask = .flexibleWidth
        
        collectionView.frame = view.bounds
        view.addSubview(collectionView)
    }
    
    open func scrollToLastItem(at pos: UICollectionView.ScrollPosition = .bottom, animated: Bool = true) {
        collectionView.scrollToLastItem(at: pos, animated: animated)
    }
    
    public func refreshControl(isDisplay: Bool) {
        if isDisplay {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.refreshControl = nil
        }
    }
    
    @objc
    private func loadMoreMessages() {
        delegate?.messageViewController(self, loadMore: { [weak self] hasMore in
            guard let self = self else { return }
            self.refreshControl.endRefreshing()
            if !hasMore {
                self.refreshControl(isDisplay: false)
            }
        })
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDelegate

extension IMMessageViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: MessagesCollectionView.resignAllResponderNotification, object: nil)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let messagesFlowLayout = collectionViewLayout as? MessagesCollectionViewFlowLayout else { return .zero }
        return messagesFlowLayout.sizeForItem(at: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError()
        }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
            fatalError()
        }
        
        return layoutDelegate.headerViewSize(for: section, in: messagesCollectionView)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError()
        }
        guard let layoutDelegate = messagesCollectionView.messagesLayoutDelegate else {
            fatalError()
        }
        
        return layoutDelegate.footerViewSize(for: section, in: messagesCollectionView)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError()
        }
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError()
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? MessageContentCell else {
            return false
        }
        
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        delegate?.messageViewController(self, showMenuForItemAt: cell, message: message)
        
        return true
    }

    public func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    }
}

// MARK: - UICollectionViewDataSource

extension IMMessageViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let collectionView = collectionView as? MessagesCollectionView else {
            fatalError()
        }
        let sections = collectionView.messagesDataSource?.numberOfSections(in: collectionView) ?? 0
        return sections
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let collectionView = collectionView as? MessagesCollectionView else {
            fatalError()
        }
        return collectionView.messagesDataSource?.numberOfItems(inSection: section, in: collectionView) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError()
        }
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else {
            fatalError()
        }

        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)

        let cell: MessageCollectionViewCell
        switch message.content {
        case .text, .unknown:
            cell = messagesCollectionView.dequeueReusableCell(TextMessageCell.self, for: indexPath)
        case .image:
            cell = messagesCollectionView.dequeueReusableCell(ImageMessageCell.self, for: indexPath)
        case .audio:
            cell = messagesCollectionView.dequeueReusableCell(AudioMessageCell.self, for: indexPath)
        case .video:
            cell = messagesCollectionView.dequeueReusableCell(VideoMessageCell.self, for: indexPath)
        case .system(_, _):
            cell = messagesCollectionView.dequeueReusableCell(SystemMessageCell.self, for: indexPath)
        }
        
        cell.configure(with: message, at: indexPath, and: messagesCollectionView)
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        guard let messagesCollectionView = collectionView as? MessagesCollectionView else {
            fatalError()
        }

        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError()
        }

        switch kind {
        case UICollectionView.elementKindSectionHeader:
            return displayDelegate.messageHeaderView(for: indexPath, in: messagesCollectionView)
        case UICollectionView.elementKindSectionFooter:
            return displayDelegate.messageFooterView(for: indexPath, in: messagesCollectionView)
        default:
            fatalError()
        }
    }
}
