//
//  LoginVC.swift
//  EEChat
//
//  Created by Snow on 2021/4/8.
//

import UIKit
import OpenIM
import web3swift

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
        guard agreementView.agree else {
            return
        }
        view.endEditing(true)
        var mnemonic = textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if mnemonic == "" {
            mnemonic = try! BIP39.generateMnemonics(bitsOfEntropy: 128)!
        }
        
        ApiUserLogin.login(mnemonic: mnemonic)
    }
    
    @IBOutlet var agreementView: AgreementView!
    
    @IBAction func registerAction() {
        if agreementView.agree {
            RegisterVC.show()
        }
    }
}
