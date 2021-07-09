//
//  Function.swift
//  EEChat
//
//  Created by Snow on 2021/5/26.
//

import Foundation
import RxSwift

func LocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

func rxRequest<Type>(showLoading: Bool = false,
                     showError: Bool = true,
                     action: @escaping ((@escaping (_ observer: Result<Type, Error>) -> Void)) -> Void ) -> Single<Type> {
    return Single.create { (observer) -> Disposable in
        if showLoading {
            MessageModule.showHUD()
        }
        action(observer)
        return Disposables.create {}
    }
    .do(onSuccess: { _ in
        if showLoading {
            MessageModule.hideHUD()
        }
    }, onError: { err in
        if showLoading {
            MessageModule.hideHUD()
        }
        if showError {
            MessageModule.showMessage(err)
        }
    })
}
