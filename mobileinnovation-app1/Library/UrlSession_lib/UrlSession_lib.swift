//
//  UrlSession_lib.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/14.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import Foundation

protocol UrlSession_libDelegate {
    func UrlSessionBack_SuccessAction(dicJson: NSDictionary)
    func UrlSessionBack_DataFailureAction(errType: String)
    func UrlSessionBack_HttpFailureAction(errCode: uint)
}

class UrlSession_lib:NSObject {

    static var STATIC_TIMEOUTINTERVALFORREQUEST: TimeInterval = 20
    static var STATIC_TIMEOUTINTERVALFORRESOURCE: TimeInterval = 20

    var urlSession_libDelegate:UrlSession_libDelegate?

    func get(currentView: BaseViewController, url urlString: String, queryItems: [URLQueryItem]? = nil, session: UrlSession_lib) {

        self.urlSession_libDelegate = currentView

        var compnents = URLComponents(string: urlString)
        compnents?.queryItems = queryItems
        let url = compnents?.url

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = UrlSession_lib.STATIC_TIMEOUTINTERVALFORREQUEST
        config.timeoutIntervalForResource = UrlSession_lib.STATIC_TIMEOUTINTERVALFORRESOURCE
        let session = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())

        let task = session.dataTask(with: url!) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data, let response = response {
                //print(response)
                //let statusCode = (response as! HTTPURLResponse).statusCode
                //print("HttpCode _ \(statusCode)")
                do {
                    let json: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    print(json)
                    self.urlSession_libDelegate?.UrlSessionBack_SuccessAction(dicJson: json)
                } catch {
                    self.urlSession_libDelegate?.UrlSessionBack_DataFailureAction(errType: "Serialize Error")
                }
            } else {
                self.urlSession_libDelegate?.UrlSessionBack_HttpFailureAction(errCode: error as! uint)
            }
        }

        task.resume()
    }


    func post(currentView: BaseViewController, url urlString: String, parameters: [String: Any]) {

        self.urlSession_libDelegate = currentView

        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"

        let parametersString: String = parameters.enumerated().reduce("") { (input, tuple) -> String in
            switch tuple.element.value {
            case let int as Int: return input + tuple.element.key + "=" + String(int) + (parameters.count - 1 > tuple.offset ? "&" : "")
            case let string as String: return input + tuple.element.key + "=" + string + (parameters.count - 1 > tuple.offset ? "&" : "")
            default: return input
            }
        }
        request.httpBody = parametersString.data(using: String.Encoding.utf8)

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = UrlSession_lib.STATIC_TIMEOUTINTERVALFORREQUEST
        config.timeoutIntervalForResource = UrlSession_lib.STATIC_TIMEOUTINTERVALFORRESOURCE
        let session = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())

        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data, let response = response {
                //print(response)
                //let statusCode = (response as! HTTPURLResponse).statusCode
                //print("HttpCode _ \(statusCode)")
                do {
                    let json: NSDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                    print(json)
                    self.urlSession_libDelegate?.UrlSessionBack_SuccessAction(dicJson: json)
                } catch {
                    self.urlSession_libDelegate?.UrlSessionBack_DataFailureAction(errType: "Serialize Error")
                }
            } else {
                self.urlSession_libDelegate?.UrlSessionBack_HttpFailureAction(errCode: error as! uint)
            }
        }
        task.resume()
    }
}
