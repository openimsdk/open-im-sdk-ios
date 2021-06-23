//
//  ApiResult.swift
//  OpenIM
//
//  Created by Snow on 2021/5/14.
//

import Foundation
import RxSwift

public typealias ApiResult = Single<Response>

public extension ApiResult {
    func map<Model: Decodable>(type _: Model.Type,
                                    keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> Single<Model> {
        return flatMap { .just(try $0.getModel(keyDecodingStrategy: keyDecodingStrategy)) }
    }
}

