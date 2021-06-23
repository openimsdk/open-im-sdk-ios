//
//  MessagesDataSource.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/8.
//

import UIKit

public protocol MessagesDataSource: AnyObject {
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int
    
    func customCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell
    
    func nameLabelAttributedText(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> NSAttributedString?
    
}

public extension MessagesDataSource {
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
}
