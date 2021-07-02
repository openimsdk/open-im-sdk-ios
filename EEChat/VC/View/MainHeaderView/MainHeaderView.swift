//
//  MainHeaderView.swift
//  EEChat
//
//  Created by Snow on 2021/4/9.
//

import UIKit

class MainHeaderView: ResuableCustomView {
    
    @IBInspectable public var title: String = "" {
        didSet {
            self.titleLabel.text = LocalizedString(title)
        }
    }
    
    @IBInspectable var showSearch: Bool = false {
        didSet {
            self.searchImageView.isHidden = !showSearch
        }
    }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var searchImageView: UIImageView!
    @IBOutlet var addImageView: UIImageView!
    @IBOutlet var bottomView: UIView!
    
    override func didLoad() {
        super.didLoad()
        let views: [UIView] = [searchImageView, addImageView]
        for (index, view) in views.enumerated() {
            _ = view.rx.tapGesture()
                .when(.ended)
                .subscribe(onNext: { [unowned self] _ in
                    switch index {
                    case 0:
                        LocalSearchUserVC.show()
                    case 1:
                        MainPopupView.show(targetView: self.addImageView)
                    default:
                        break
                    }
                })
        }
        
        let layer = bottomView.layer
        layer.shadowColor = UIColor.eec.rgb(0x0, alpha: 0.15).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 1
        layer.shadowRadius = 1
        layer.cornerRadius = 4
    }
    
}
