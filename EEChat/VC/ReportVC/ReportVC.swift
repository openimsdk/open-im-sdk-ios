//
//  ReportVC.swift
//  EEChat
//
//  Created by Snow on 2021/7/7.
//

import UIKit

class ReportVC: BaseViewController {

    @IBOutlet var btnContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshBtns()
    }
    
    private func refreshBtns(_ sender: UIButton? = nil) {
        btnContainerView.subviews.forEach { view in
            if let btn = view as? UIButton {
                btn.setTitleColor(UIColor.eec_rgb(0x333333), for: .normal)
                btn.backgroundColor = .white
                btn.layer.borderColor = UIColor.eec_rgb(0xCCCCCC).cgColor
            }
        }
        if let btn = sender {
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = UIColor.eec_rgb(0x1B72EC)
            btn.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private var reason: String?
    @IBAction func btnAction(_ sender: UIButton) {
        refreshBtns(sender)
        reason = sender.title(for: .normal)
    }
    
    private var iamge: UIImage?
    @IBOutlet var albumBtn: UIButton!
    @IBAction func albumAction(_ sender: Any) {
        PhotoModule.shared.showPicker(type: .image, allowTake: true, allowCrop: false, cropSize: .zero) { [weak self] image, _ in
            guard let self = self else { return }
            self.iamge = image
            self.albumBtn.setImage(image, for: .normal)
        }
    }
    
    @IBAction func submitAction() {
        guard let reason = self.reason else {
            MessageModule.showMessage("Please select the reason!")
            return
        }
        guard let iamge = self.iamge else {
            MessageModule.showMessage("Please select the iamge!")
            return
        }
        MessageModule.showHUD()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            MessageModule.hideHUD()
            MessageModule.showMessage("Feedback success")
        }
    }
}
