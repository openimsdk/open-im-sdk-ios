//
//  .swift
//  EEChat
//
//  Created by Snow on 2021/4/25.
//

import UIKit

class SwitchView: UISwitch {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.transform = CGAffineTransform.identity.scaledBy(x: 0.66, y: 0.66)
    }

}
