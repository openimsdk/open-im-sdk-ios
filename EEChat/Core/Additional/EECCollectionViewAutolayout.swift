//
//  EECCollectionViewAutolayout.swift
//  EEChat
//
//  Created by Snow on 2021/4/8.
//

import UIKit

open class EECCollectionAutolayoutViewCell: UICollectionViewCell {
    open override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        layoutIfNeeded()
        let layoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        return layoutAttributes
    }
}

open class EECCollectionViewAutolayout: UICollectionViewFlowLayout {
    public enum Align {
        case none
        case left
        case right
        case center
    }

    private var align = Align.left

    // itemSize != nil: Fixed width high
    // estimatedItemSize != nil: Auto width high
    public init(align: Align = .left, itemSize: CGSize? = nil, estimatedItemSize: CGSize? = nil) {
        super.init()
        self.align = align
        assert(itemSize != nil || estimatedItemSize != nil)
        if let estimatedItemSize = estimatedItemSize {
            self.estimatedItemSize = estimatedItemSize
        } else if let itemSize = itemSize {
            self.itemSize = itemSize
        }
    }

    public init(layout: UICollectionViewLayout, align: Align = .left) {
        super.init()
        assert(layout is UICollectionViewFlowLayout, "无效类型")
        let layout = layout as! UICollectionViewFlowLayout
        self.align = align

        minimumLineSpacing = layout.minimumLineSpacing
        minimumInteritemSpacing = layout.minimumInteritemSpacing
        itemSize = layout.itemSize
        estimatedItemSize = layout.estimatedItemSize
        scrollDirection = layout.scrollDirection
        headerReferenceSize = layout.headerReferenceSize
        footerReferenceSize = layout.footerReferenceSize
        sectionInset = layout.sectionInset
        sectionInsetReference = layout.sectionInsetReference
        sectionHeadersPinToVisibleBounds = layout.sectionHeadersPinToVisibleBounds
        sectionFootersPinToVisibleBounds = layout.sectionFootersPinToVisibleBounds
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let elements = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        if align != .none {
            let group = elements.reduce(into: [Int: [UICollectionViewLayoutAttributes]]()) { result, attributes in
                let key = Int(attributes.frame.origin.y)
                if result[key] == nil {
                    result[key] = []
                }
                result[key]!.append(attributes)
            }

            switch align {
            case .left:
                group.forEach { _, array in
                    var x: CGFloat = self.sectionInset.left
                    array.forEach { attributes in
                        var frame = attributes.frame
                        frame.origin.x = x
                        attributes.frame = frame
                        x = frame.maxX + self.minimumInteritemSpacing
                    }
                }
            case .right:
                group.forEach { _, array in
                    var x: CGFloat = rect.size.width - self.sectionInset.right
                    array.reversed().forEach { attributes in
                        var frame = attributes.frame
                        frame.origin.x = x - frame.size.width
                        attributes.frame = frame

                        x = frame.origin.x - self.minimumInteritemSpacing
                    }
                }
            case .center:
                group.forEach { _, array in
                    var width = array.reduce(CGFloat(0)) { (sum, attributes) -> CGFloat in
                        sum + attributes.size.width
                    }
                    width += self.minimumInteritemSpacing * CGFloat(array.count - 1)
                    var x: CGFloat = ((self.collectionView?.frame.width ?? 0) - width) * 0.5
                    array.forEach { attributes in
                        var frame = attributes.frame
                        frame.origin.x = x
                        attributes.frame = frame

                        x = frame.maxX + self.minimumInteritemSpacing
                    }
                }
            default:
                break
            }
        }

        return elements
    }
}
