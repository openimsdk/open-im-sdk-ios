//
//  RegisterNextVC.swift
//  EEChat
//
//  Created by Snow on 2021/4/9.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterNextVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        bindAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private lazy var mnemonic: String = {
        assert(self.param is String, "无效参数")
        return self.param as! String
    }()
    
    let relay = BehaviorRelay(value: Array(repeating: "", count: 12))
    
    @IBOutlet var resultCollectionView: UICollectionView!
    @IBOutlet var inputCollectionView: UICollectionView!
    
    private func bindAction() {
        resultCollectionView.eec.autoHeight()
            .disposed(by: disposeBag)
        
        resultCollectionView.collectionViewLayout = EECCollectionViewAutolayout(layout: resultCollectionView.collectionViewLayout,
                                                                                align: .center)

        relay
            .bind(to: resultCollectionView.rx.items(cellIdentifier: "cell", cellType: UICollectionViewCell.self))
            { [unowned self] row, element, cell in
                let indexLabel = cell.contentView.viewWithTag(1) as! UILabel
                let imageView = cell.contentView.viewWithTag(2) as! UIImageView
                let textLabel = cell.contentView.viewWithTag(3) as! UILabel
                indexLabel.text = "\(row)."
                textLabel.text = element

                imageView.image = {
                    if element != "" {
                        return UIImage(named: "register_icon_2")
                    }
                    if self.relay.value.firstIndex(of: "") == row {
                        return UIImage(named: "register_icon_1")
                    }
                    return UIImage(named: "register_icon_0")
                }()
            }
            .disposed(by: disposeBag)
        
        resultCollectionView.rx.modelSelected(String.self)
            .subscribe(onNext: { [unowned self] (text) in
                if text != "" {
                    self.replace(text: text)
                }
            })
            .disposed(by: disposeBag)
        
        inputCollectionView.eec.autoHeight()
            .disposed(by: disposeBag)
        
        inputCollectionView.collectionViewLayout = EECCollectionViewAutolayout(layout: inputCollectionView.collectionViewLayout,
                                                                               align: .center)
        
        var array = mnemonic.split(separator: " ").map{ String($0) }
        for index in 0..<array.count {
            let newIndex = (Int(arc4random()) & 0xFFFF) % array.count
            (array[newIndex], array[index]) = (array[index], array[newIndex])
        }
        
        Single.just(array)
            .asObservable()
            .bind(to: inputCollectionView.rx.items(cellIdentifier: "cell",
                                                   cellType: UICollectionViewCell.self))
            { [unowned self] row, element, cell in
                let imageView = cell.viewWithTag(1) as! UIImageView
                let label = cell.viewWithTag(2) as! UILabel
                label.text = element
                imageView.isHighlighted = self.relay.value.contains(element)
            }
            .disposed(by: disposeBag)
        
        inputCollectionView.rx.modelSelected(String.self)
            .subscribe(onNext: { [unowned self] (text) in
                self.replace(text: text)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func replace(text: String) {
        var array = relay.value
        if let index = relay.value.firstIndex(of: text) {
            array[index] = ""
        } else if let index = array.firstIndex(of: "") {
            array[index] = text
        }
        relay.accept(array)
        self.inputCollectionView.reloadData()
    }

    @IBAction func loginAction() {
        if self.relay.value.joined(separator: " ") != self.mnemonic {
            MessageModule.showMessage(LocalizedString("The order of the mnemonic words is incorrect!"))
            return
        }
        
        ApiUserLogin.login(mnemonic: self.mnemonic)
    }
}
