//
//  MainPopupView.swift
//  EEChat
//
//  Created by Snow on 2021/4/20.
//

import UIKit

final class MainPopupView: ResuableCustomView {

    static func show(targetView: UIView) {
        EECPopupVC.show { (popupVC) in
            let view = MainPopupView()
            popupVC.view.addSubview(view)
            let rect = targetView.convert(targetView.bounds, to: popupVC.view)
            view.snp.makeConstraints { (make) in
                make.top.equalTo(rect.maxY - 10)
                make.left.equalTo(rect.minX - 103)
            }
        }
    }
    
    override func didLoad() {
        super.didLoad()
        
        let views: [UIView] = (1...3).map { self.viewWithTag($0)! }
        
        for (index, view) in views.enumerated() {
            _ = view.rx.tapGesture()
                .when(.ended)
                .subscribe(onNext: { _ in
                    NavigationModule.shared.dismiss {
                        switch index {
                        case 0:
                            SearchUserVC.show()
                        case 1:
                            break
                        case 2:
                            break
                        default:
                            fatalError()
                        }
                    }
                })
        }
    }

}
