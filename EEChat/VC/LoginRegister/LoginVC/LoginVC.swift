//
//  LoginVC.swift
//  EEChat
//
//  Created by Snow on 2021/4/8.
//

import UIKit
import OpenIM

class LoginVC: BaseViewController {
    static let cacheKey = "LoginVC.cacheKey"

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = DBModule.shared.get(key: LoginVC.cacheKey)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBOutlet var textField: UITextField!
    @IBAction func loginAction() {
        let mnemonic = textField.text!
        if mnemonic == "" {
            MessageModule.showMessage(text: LocalizedString("Please enter mnemonic words!"))
            return
        }
        
        ApiUserLogin.login(mnemonic: mnemonic)
    }
    
    @IBAction func registerAction() {
        RegisterVC.show()
    }
}
