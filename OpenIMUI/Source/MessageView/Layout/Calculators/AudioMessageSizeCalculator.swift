//
//  AudioMessageSizeCalculator.swift
//  OpenIMUI
//
//  Created by Snow on 2021/5/20.
//

import UIKit

open class AudioMessageSizeCalculator: MessageSizeCalculator {
    
    open override func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        switch message.content {
        case .audio(let item):
            let duration = item.duration
            return CGSize(width: CGFloat(duration) * 1.5 + 70, height: 34)
        default:
            fatalError()
        }
    }

}
