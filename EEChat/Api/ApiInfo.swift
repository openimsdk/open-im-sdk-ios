//
//  ApiInfo.swift
//  EEChat
//
//  Created by snow on 2021/3/27.
//

import Foundation
import Alamofire
import OpenIM

public struct ApiInfo: ApiTarget {
    
    public init(path: String) {
        self.path = path
    }
    
    public let baseURL: URL = URL(string: "http://47.112.160.66:20000")!
    
    public let path: String
    
    public let method: HTTPMethod = .post
    
    public var headers: [String : String]?

    public var encoder: ParameterEncoder = JSONParameterEncoder.default
    
    public var processor: ApiProcessor {
        return ApiInfoProcessor.default
    }
}

public struct ApiInfoProcessor: ApiProcessor {
    public static let `default` = ApiInfoProcessor()
    private init(){}
    
    var headers: [String : String]?
    
    public func willRequest<Parameters>(target: ApiTarget, parameters: Parameters) -> (ApiTarget, Parameters) where Parameters : Encodable {
        return (target, parameters)
    }
    
    public func willResponse(target: ApiTarget, data: Data, response: HTTPURLResponse) throws -> Response {
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
            let message = response.statusCode != 200 ? "Request failed" : "Parsing data error"
            throw NSError(domain: target.path,
                          code: response.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: message])
        }
        
        if let dict = jsonObject as? [String: Any],
           let code = dict["errCode"] as? Int
        {
            let message = dict["errMsg"] as? String ?? ""
            if code != 0 {
                throw NSError(domain: target.path, code: code, userInfo: [NSLocalizedDescriptionKey: message])
            }
            
            var response = Response(code: code, message: message)
            switch dict["data"] {
            case let array as [Any]:
                response.content = array
            case let dict as [String: Any]:
                let arrayKey = ["refreshTag"]
                for key in arrayKey {
                    if let refreshTag = dict[key] {
                        if let value = refreshTag as? Int {
                            response.refreshTag = String(value)
                        } else {
                            response.refreshTag = (refreshTag as! String)
                        }
                        break
                    }
                }
                response.content = dict
            default:
                response.content = dict
            }
            
            return response
        }
        
        let message = "Response data error"
        throw NSError(domain: target.path, code: 0, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
