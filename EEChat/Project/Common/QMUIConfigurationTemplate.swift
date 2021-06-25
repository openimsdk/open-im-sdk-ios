//
//  QMUIConfigurationTemplate.swift
//  EEChat
//
//  Created by Snow on 2021/6/25.
//

import UIKit

class QMUIConfigurationTemplate: NSObject, QMUIConfigurationTemplateProtocol {
    
    func shouldApplyTemplateAutomatically() -> Bool {
        return true
    }
    
    func applyConfigurationTemplate() {
        guard let config = QMUIConfiguration.sharedInstance() else {
            return
        }
        config.updatesIndicatorSize = CGSize(width: 7, height: 7)
        config.updatesIndicatorOffset = CGPoint(x: 4, y: config.updatesIndicatorSize.height)
        config.updatesIndicatorColor = .red
    }
}
