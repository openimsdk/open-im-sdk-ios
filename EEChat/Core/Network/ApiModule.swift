//
//  ApiModule.swift
//  OpenIM
//
//  Created by Snow on 2021/4/9.
//

import Foundation
import Alamofire
import RxSwift

public final class ApiModule {
    public static let shared = ApiModule()
    private init() {}
    
    private lazy var session: Alamofire.Session = {
        let session = Alamofire.Session.default
        session.session.configuration.timeoutIntervalForRequest = 5
        session.session.configuration.timeoutIntervalForResource = 10
        return session
    }()
    
    func request<Parameters: Encodable>(_ target: ApiTarget,
                                        parameters: Parameters? = nil,
                                        callback: @escaping (Result<Response, Error>) -> Void) -> DataRequest {
        
        let processor = target.processor
        let (target, parameters) = processor.willRequest(target: target, parameters: parameters)
        
        let url = target.baseURL.appendingPathComponent(target.path)
        let headers: HTTPHeaders? = {
            if let headers = target.headers {
                return HTTPHeaders(headers)
                
            }
            return nil
        }()
        
        return session.request(url, method: target.method, parameters: parameters, encoder: target.encoder, headers: headers)
            .response(completionHandler: { (result) in
                do {
                    if let error = result.error {
                        throw error
                    }
                    
                    guard let response = result.response, let data = result.data else {
                        let message = "Request failed"
                        let error = NSError(domain: target.path,
                                            code: 0,
                                            userInfo: [NSLocalizedDescriptionKey: message])
                        throw error
                    }
                    
                    let resp = try processor.willResponse(target: target, data: data, response: response)
                    callback(.success(resp))
                    
                    self.printLog(target, params: parameters, result: data)
                } catch {
                    self.printLog(target, params: parameters, result: error)
                    callback(.failure(error))
                }
            })
    }
}

extension ApiModule {
    
    func request<Parameters: Encodable>(_ target: ApiTarget,
                                        parameters: Parameters?,
                                        showLoading: Bool = false,
                                        showError: Bool = true) -> ApiResult {
        func runInMain(execute work: @escaping @convention(block) () -> Void) {
            if Thread.isMainThread {
                work()
            } else {
                DispatchQueue.main.async(execute: work)
            }
        }
        
        if showLoading {
            runInMain {
                MessageModule.showHUD(text: LocalizedString("Requesting..."))
            }
        }
        
        let showError = showError && Thread.isMainThread && UIApplication.shared.applicationState == .active
        
        return ApiResult.create(subscribe: { (observer) -> Disposable in
            let task = self.request(target, parameters: parameters) { (result) in
                observer(result)
                if showLoading {
                    runInMain {
                        MessageModule.hideHUD(animated: true)
                    }
                }
                if showError, case let Result.failure(error) = result {
                    let error = error as NSError
                    if ![0, 200].contains(error.code) {
                        runInMain {
                            MessageModule.showMessage(error)
                        }
                    }
                }
            }
            
            return Disposables.create {
                task.cancel()
            }
        })
    }
}

extension ApiModule {
    private func printLog<Parameters: Encodable>(_ target: ApiTarget, params: Parameters, result: Any) {
        #if DEBUG
        print("\n<<<------------------------------")
        func format(_ any: Any) -> String {
            let data = try? JSONSerialization.data(withJSONObject: any, options: .prettyPrinted)
            return String(data: data ?? Data(), encoding: String.Encoding.utf8) ?? ""
        }
        
        switch result {
        case let data as Data:
            let object = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            if let object = object {
                print(format(object))
            } else {
                print(String(data: data, encoding: .utf8) ?? "")
            }
        case let err as Error:
            print(err)
        default:
            break
        }

        print("\(target.baseURL.appendingPathComponent(target.path))")
        
        if let data = try? JSONEncoder().encode(params),
           let obj = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) {
            print(format(obj))
        }

        print("------------------------------>>>\n")
        #endif
    }
}
