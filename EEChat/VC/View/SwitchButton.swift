//
//  SwitchButton.swift
//  EEChat
//
//  Created by Snow on 2021/6/28.
//

import UIKit

class SwitchButton: UIButton {

    override var isSelected: Bool {
        didSet {
            let image = isSelected ? UIImage(named: "icon_switch_on") : UIImage(named: "icon_switch_off")
            setImage(image, for: .normal)
        }
    }

}
