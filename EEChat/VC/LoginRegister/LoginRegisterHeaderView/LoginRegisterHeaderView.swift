//
//  LoginRegisterHeaderView.swift
//  EEChat
//
//  Created by Snow on 2021/4/9.
//

import UIKit

class LoginRegisterHeaderView: ResuableCustomView {
    
    @IBInspectable public var title: String = "" {
        didSet {
            self.titleLabel.text = title
        }
    }

    @IBOutlet var titleLabel: UILabel!
    
    @IBAction func popAction() {
        NavigationModule.shared.pop()
    }
    
}
