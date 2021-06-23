//
//  SystemMessageSizeCalculator.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/27.
//

import UIKit

open class SystemMessageSizeCalculator: CellSizeCalculator {
    
    open override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        return CGSize(width: messagesLayout.itemWidth, height: 30)
    }
    
}
