//
//  UIScrollView+EEC.swift
//  EEChat
//
//  Created by Snow on 2021/4/8.
//

import Foundation
import RxGesture
import RxSwift
import SnapKit

private var AssociatedKey: UInt8 = 0

public extension Namespace where Base: UIScrollView {
    func srollToTop() {
        let point = CGPoint(x: -base.adjustedContentInset.left, y: -base.adjustedContentInset.top)
        if let tableView = base as? UITableView {
            // tableView 预测高度时滚动错误的bug
            for section in 0 ..< tableView.numberOfSections {
                if tableView.numberOfRows(inSection: section) > 0 {
                    tableView.scrollToRow(at: IndexPath(row: 0, section: section),
                                          at: .none,
                                          animated: true)
                    if tableView.tableHeaderView != nil {
                        CATransaction.setCompletionBlock {
                            tableView.setContentOffset(point, animated: true)
                        }
                    }
                    return
                }
            }
        }

        base.setContentOffset(point, animated: true)
    }

    // 自动高度 nil 则自动为当前contentSize高度
    func autoHeight(maxHeight: CGFloat? = nil) -> Disposable {
        if objc_getAssociatedObject(base, &AssociatedKey) == nil {
            objc_setAssociatedObject(base, &AssociatedKey, true, .OBJC_ASSOCIATION_ASSIGN)
            let constraint = base.constraints.first { (constraint) -> Bool in
                constraint.relation == .equal && (constraint.firstItem as? UIView) == base
            }
            if let constraint = constraint {
                base.removeConstraint(constraint)
            }
            base.snp.makeConstraints { make in
                make.height.equalTo(0)
            }
        }
        return base.rx.observe(CGSize.self, #keyPath(UIScrollView.contentSize))
            .take(until: base.superview!.rx.deallocating)
            .map { (size) -> CGFloat in
                if let maxHeight = maxHeight {
                    return size!.height > maxHeight ? maxHeight : size!.height
                } else {
                    return size!.height
                }
            }
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned base] height in
                base.snp.updateConstraints { make in
                    make.height.equalTo(height)
                }
            })
    }
}

