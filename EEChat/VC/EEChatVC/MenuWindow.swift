//
//  MenuWindow.swift
//  EEChat
//
//  Created by Snow on 2021/4/22.
//

import UIKit

class MenuItemCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(7)
            make.centerX.equalToSuperview()
        }
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10)
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-7)
        }
        return label
    }()
    
    var item: MenuItem! {
        didSet {
            imageView.image = item.image
            titleLabel.text = item.title
        }
    }
}

struct MenuItem {
    let title: String
    let image: UIImage?
    let callback: () -> Void
}

class MenuContentView: UIView {
    
    var itemWidth: CGFloat = 44
    
    lazy var imageView: UIImageView = {
        let image = UIImage(named: "chat_popup_bg")?
            .resizableImage(withCapInsets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                            resizingMode: .stretch)
        
        let imageView = UIImageView(image: image)
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return imageView
    }()
    
    lazy var arrowImageView: UIImageView = {
        let image = UIImage(named: "chat_popup_arrow")
        let imageView = UIImageView(image: image)
        addSubview(imageView)
        return imageView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: self.itemWidth, height: 46)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            make.width.equalTo(self.itemWidth)
            make.height.equalTo(46)
        }
        
        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: "cell")
        
        self.sendSubviewToBack(imageView)
        
        return collectionView
    }()
    
    var dataSource: [MenuItem] = [] {
        didSet {
            collectionView.snp.updateConstraints { (make) in
                make.width.equalTo(CGFloat(dataSource.count) * self.itemWidth)
            }
            collectionView.reloadData()
        }
    }
}

extension MenuContentView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.superview?.isHidden = true
        
        let item = dataSource[indexPath.row]
        item.callback()
    }
}

extension MenuContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            as! MenuItemCell
        cell.item = dataSource[indexPath.row]
        return cell
    }
}

class MenuWindow: UIWindow {
    
    lazy var contentView: MenuContentView = {
        let view = MenuContentView()
        addSubview(view)
        return view
    }()
    
    override var isHidden: Bool {
        didSet {
            if isHidden {
                resignKey()
            } else {
                makeKeyAndVisible()
            }
        }
    }
    
    func show(targetView: UIView, items: [MenuItem]) {
        backgroundColor = .clear
        isHidden = false
        
        contentView.dataSource = items
        let rect = targetView.convert(targetView.bounds, to: self)
        
        let arrowImageView = contentView.arrowImageView
        var offsetY: CGFloat = 0
        var isInUp = true
        
        if rect.minY < bounds.height / 3 && rect.maxY > bounds.height / 3 * 2 {
            offsetY = bounds.height / 3
        } else if rect.minY < bounds.height / 3 {
            isInUp = false
            offsetY = rect.maxY + 10
        } else {
            offsetY = rect.minY - 46 - 10
        }
        
        if isInUp {
            arrowImageView.transform = CGAffineTransform(rotationAngle: 0)
            arrowImageView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalTo(contentView.snp.bottom).offset(-6)
            }
        } else {
            arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            arrowImageView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(contentView.snp.top).offset(6)
            }
        }
        
        contentView.snp.remakeConstraints { (make) in
            make.centerX.equalTo(rect.midX)
            make.top.equalTo(offsetY)
        }
        
    }

    @objc func hide() {
        isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        hide()
    }
}
