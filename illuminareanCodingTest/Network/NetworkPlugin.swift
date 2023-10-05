//
//  NetworkPlugin.swift
//  illuminareanCodingTest
//
//  Created by 최제환 on 10/4/23.
//

import Foundation
import Moya

/**
 provider를 이용하여 네트워크 호출을 하는데, provider를 생성할 때 plugin을 넣어주면 willSend, didReceive, onSucceed, onFail에 관한것을 정의하여 log 확인 용도
 
 참고자료: https://leejigun.github.io/Swift_Moya_Provider_custom
 */
struct NetworkLoggerPlugin: PluginType {
    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            print("[HTTP Request] invalid request")
            return
        }
        
        let url = httpRequest.description
        let method = httpRequest.httpMethod ?? "unknown method"
        
        var httpLog = """
                ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️
                [HTTP Request]
                URL: \(url)
                TARGET: \(target)
                METHOD: \(method)\n
                """
        
        httpLog.append("HEADER: [\n")
        httpRequest.allHTTPHeaderFields?.forEach {
            httpLog.append("\t\($0): \($1)\n")
        }
        httpLog.append("]\n")
        
        if let body = httpRequest.httpBody, let bodyString = String(bytes: body, encoding: .utf8) {
            httpLog.append("BODY: \n\(bodyString)\n")
        }
        httpLog.append("[HTTP REQUEST END]\nℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️ℹ️")
        
        print(httpLog)
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let.success(response):
            onSucceed(response, target: target, isFromError: false)
        case let .failure(error):
            onFail(error, target: target)
        }
    }

    func onSucceed(_ response: Response, target: TargetType, isFromError: Bool) {
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode

        var httpLog = """
                ✅✅✅✅✅✅✅✅✅✅
                [HTTP Response]
                TARGET: \(target)
                URL: \(url)
                STATUS CODE: \(statusCode)\n
                """

        httpLog.append("HEADER: [\n")
        response.response?.allHeaderFields.forEach {
            httpLog.append("\t\($0): \($1)\n")
        }
        httpLog.append("]\n")

        httpLog.append("RESPONSE DATA: \n")
        if let responseString = String(bytes: response.data, encoding: .utf8) {
            httpLog.append("\(responseString)\n")
        }
        httpLog.append("[HTTP Response End]\n✅✅✅✅✅✅✅✅✅✅")

        print(httpLog)
    }

    func onFail(_ error: MoyaError, target: TargetType) {
        if let response = error.response {
            onSucceed(response, target: target, isFromError: true)
            return
        }

        var httpLog = """
                ❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️
                [HTTP Error]
                TARGET: \(target)
                ERRORCODE: \(error.errorCode)\n
                """
        httpLog.append("MESSAGE: \(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
        httpLog.append("[HTTP Error End]\n❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️")

        print(httpLog)
    }
}
