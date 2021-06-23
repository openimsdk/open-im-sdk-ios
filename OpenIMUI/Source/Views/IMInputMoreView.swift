//
//  IMInputMoreView.swift
//  MessageKit
//
//  Created by Snow on 2021/6/4.
//

import UIKit

public protocol IMInputMoreViewDelegate: AnyObject {
    func inputMoreView(_ inputMoreView: IMInputMoreView, didSelectMore item: IMInputMoreItem, index: Int)
}

open class IMInputMoreView: UIView {
    
    public weak var delegate: IMInputMoreViewDelegate?
    
    open lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        return layout
    }()
    
    open lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(IMInputMoreCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        return collectionView
    }()
    
    public var maxRowCount: Int = 5 {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if !items.isEmpty {
            let width = floor(bounds.width / CGFloat(min(items.count, maxRowCount)))
            let height = floor(bounds.height / CGFloat(max(items.count / maxRowCount, 1)))
            flowLayout.itemSize = CGSize(width: width, height: height)
        }
    }
    
    public var items: [IMInputMoreItem] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

}

extension IMInputMoreView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        delegate?.inputMoreView(self, didSelectMore: item, index: indexPath.row)
    }
}

extension IMInputMoreView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! IMInputMoreCell
        cell.item = items[indexPath.row]
        return cell
    }
}
