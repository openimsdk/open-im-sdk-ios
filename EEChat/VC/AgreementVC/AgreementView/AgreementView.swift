//
//  AgreementView.swift
//  EEChat
//
//  Created by Snow on 2021/7/7.
//

import UIKit

class AgreementView: ResuableCustomView {
    
    @IBOutlet var agreeBtn: UIButton!
    var agree: Bool {
        let agree = agreeBtn.isSelected
        if !agree {
            MessageModule.showMessage("You have to agree \"user registration and use of APP privacy agreement\"")
        }
        return agree
    }
    
    
    @IBAction func selectAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.setImage(UIImage(named: "login_icon_checked"), for: .normal)
        } else {
            sender.setImage(UIImage(named: "login_icon_unchecked"), for: .normal)
        }
    }
    
    @IBAction func agreementAction(_ sender: UIButton) {
        AgreementVC.show()
    }
    
}
