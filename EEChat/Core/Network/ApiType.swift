//
//  ApiType.swift
//  XXFramework
//
//  Created by snow on 2018/11/29.
//  Copyright © 2018 snow. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

public protocol ApiTarget {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var encoder: ParameterEncoder { get }
    
    var processor: ApiProcessor { get }
}


// MARK: - ApiType

public protocol ApiType {
    var apiTarget: ApiTarget { get }
    
    associatedtype ParamType
    var param: ParamType { get }
}

public extension ApiType {
    
    func request(showLoading: Bool = false,
                 showError: Bool = true) -> Single<Response> where ParamType: Encodable {
        return self.request(param: self.param, showLoading: showLoading, showError: showError)
    }
    
    func request<ParamType: Encodable>(param: ParamType,
                                       showLoading: Bool = false,
                                       showError: Bool = true) -> Single<Response> {
        return ApiModule.shared.request(apiTarget, parameters: param, showLoading: showLoading, showError: showError)
    }
    
}


