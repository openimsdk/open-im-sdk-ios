//
//  MediaMessageSizeCalculator.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/20.
//

import UIKit

open class MediaMessageSizeCalculator: MessageSizeCalculator {
    
    public var minPt: CGFloat = 50
    public var maxPt: CGFloat = 150

    open override func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        func size(width: Int, height: Int) -> CGSize {
            var width = max(CGFloat(width), minPt)
            var height = max(CGFloat(height), minPt)
            
            let aspectRatio = min(maxPt / width, maxPt / height)
            if aspectRatio < 1 {
                width = max(width * aspectRatio, minPt)
                height = max(height * aspectRatio, minPt)
            }
            
            return CGSize(width: floor(width), height: floor(height))
        }
        
        switch message.content {
        case .image(let item):
            return size(width: item.width, height: item.height)
        case .video(let item):
            return size(width: item.width, height: item.height)
        default:
            fatalError()
        }
    }
    
}
