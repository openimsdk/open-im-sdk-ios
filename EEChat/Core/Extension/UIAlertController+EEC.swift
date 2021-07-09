//
//  UIAlertController+EEC.swift
//  EEChat
//
//  Created by Snow on 2021/4/23.
//

import UIKit

extension UIAlertController {
    static func show(title: String?,
                     message: String?,
                     buttons: [String],
                     cancel: String?,
                     didSelect: ((Int) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        var index = 0
        if let cancel = cancel {
            alertController.addAction(UIAlertAction(title: cancel, style: .cancel, handler: { (_) in
                didSelect?(0)
            }))
            index += 1
        }
        
        let style: UIAlertAction.Style = buttons.count == 1 ? .destructive : .default
        buttons.forEach { (title) in
            let tag = index
            alertController.addAction(UIAlertAction(title: title, style: style, handler: { (_) in
                didSelect?(tag)
            }))
            index += 1
        }
        
        NavigationModule.shared.present(vc: alertController)
    }
    
    static func show(title: String?,
                     message: String?,
                     text: String?,
                     placeholder: String,
                     callback: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = placeholder
            textField.font = UIFont.systemFont(ofSize: 14)
            textField.textColor = UIColor.eec.rgb(0x333333)
            textField.text = text
            textField.selectAll(nil)
        }
        alertController.addAction(UIAlertAction(title: LocalizedString("Yes"),
                                                style: .default,
                                                handler: { [unowned alertController] (_) in
            let textField = alertController.textFields!.first!
            callback(textField.text!)
        }))
        
        alertController.addAction(UIAlertAction(title: LocalizedString("No"),
                                                style: .cancel,
                                                handler: nil))
        
        NavigationModule.shared.present(vc: alertController)
    }
}
