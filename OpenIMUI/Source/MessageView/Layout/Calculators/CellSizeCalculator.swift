//
//  CellSizeCalculator.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/8.
//

import UIKit

open class CellSizeCalculator {
    
    public weak var layout: UICollectionViewFlowLayout?
    
    open func configure(attributes: UICollectionViewLayoutAttributes) {}
    
    open func sizeForItem(at indexPath: IndexPath) -> CGSize { return .zero }
    
    public init() {}
    
    public init(layout: MessagesCollectionViewFlowLayout? = nil) {
        self.layout = layout
    }

    public var messagesLayout: MessagesCollectionViewFlowLayout {
        guard let layout = layout as? MessagesCollectionViewFlowLayout else {
            fatalError("Layout object is missing or is not a MessagesCollectionViewFlowLayout")
        }
        return layout
    }

}
