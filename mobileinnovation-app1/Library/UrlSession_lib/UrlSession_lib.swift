//
//  UrlSession_lib.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/14.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol UrlSession_libDelegate {
    func UrlSessionBack_SuccessAction(urlSession_lib: UrlSession_lib, currentView: BaseViewController, json: JSON)
    func UrlSessionBack_DataFailureAction(urlSession_lib: UrlSession_lib, statusErrCode: Int, errType: String)
    func UrlSessionBack_HttpFailureAction(errType: String)
}

class UrlSession_lib:NSObject {

    static var STATIC_TIMEOUTINTERVALFORREQUEST: TimeInterval = 10
    static var STATIC_TIMEOUTINTERVALFORRESOURCE: TimeInterval = 10

    var urlSession_libDelegate:UrlSession_libDelegate?

    func get(urlSession_lib: UrlSession_lib, currentView: BaseViewController, url urlString: String, queryItems: [URLQueryItem]? = nil) {

        // 通信状態確認
        let reachability = AMReachability()
        if (reachability?.isReachable) == false {
            self.urlSession_libDelegate?.UrlSessionBack_HttpFailureAction(errType: "Internet Error")
        }

        var totalUrl: String = ""
        #if DEBUG
            // 本体のAPP_CODE取得
            let path = Bundle.main.path(forResource: "propaty", ofType: "plist")
            let dictionary = NSDictionary(contentsOfFile: path!)
            let domainName: AnyObject = dictionary?.object(forKey: "DomainName_Staging") as AnyObject

            totalUrl = (domainName as! String) + urlString
        #elseif STAGING
            // 本体のAPP_CODE取得
            let path = Bundle.main.path(forResource: "propaty", ofType: "plist")
            let dictionary = NSDictionary(contentsOfFile: path!)
            let domainName: AnyObject = dictionary?.object(forKey: "DomainName_Production") as AnyObject

            totalUrl = domainName + urlString
        #else
            // 本体のAPP_CODE取得
            let path = Bundle.main.path(forResource: "propaty", ofType: "plist")
            let dictionary = NSDictionary(contentsOfFile: path!)
            let domainName: AnyObject = dictionary?.object(forKey: "DomainName_Production") as AnyObject

            totalUrl = domainName + urlString
        #endif

        self.urlSession_libDelegate = currentView

        var compnents = URLComponents(string: totalUrl)
        compnents?.queryItems = queryItems
        let url = compnents?.url

        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = UrlSession_lib.STATIC_TIMEOUTINTERVALFORREQUEST
        config.timeoutIntervalForResource = UrlSession_lib.STATIC_TIMEOUTINTERVALFORRESOURCE
        let session = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: OperationQueue())

        let task = session.dataTask(with: url!) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data, let response = response {
                //print(response)
                let statusCode: Int = (response as! HTTPURLResponse).statusCode
                print("HttpStatusCode : \(statusCode)")
                if statusCode == 200 {
                    let json = JSON(data: data)
                    print("\(json)")
                    self.urlSession_libDelegate?.UrlSessionBack_SuccessAction(urlSession_lib: urlSession_lib, currentView: currentView, json: json)
                }else{
                    self.urlSession_libDelegate?.UrlSessionBack_DataFailureAction(urlSession_lib: urlSession_lib, statusErrCode: statusCode, errType: "Serialize Error")
                }
            } else {
                self.urlSession_libDelegate?.UrlSessionBack_HttpFailureAction(errType: "Internet Error")
            }
        }

        task.resume()
    }


    func post(urlSession_lib: UrlSession_lib, currentView: BaseViewController, url urlString: String, parameters: [String: Any]) {

        // 通信状態確認
        let reachability = AMReachability()
        if (reachability?.isReachable) == false {
            self.urlSession_libDelegate?.UrlSessionBack_HttpFailureAction(errType: "Internet Error")
        }

        var totalUrl: String = ""
        #if DEBUG
            // 本体のAPP_CODE取得
            let path = Bundle.main.path(forResource: "propaty", ofType: "plist")
            let dictionary = NSDictionary(contentsOfFile: path!)
            let domainName: AnyObject = dictionary?.object(forKey: "DomainName_Staging") as AnyObject

            totalUrl = (domainName as! String) + urlString
        #elseif STAGING
            // 本体のAPP_CODE取得
            let path = Bundle.main.path(forResource: "propaty", ofType: "plist")
            let dictionary = NSDictionary(contentsOfFile: path!)
            let domainName: AnyObject = dictionary?.object(forKey: "DomainName_Production") as AnyObject

            totalUrl = domainName + urlString
        #else
            // 本体のAPP_CODE取得
            let path = Bundle.main.path(forResource: "propaty", ofType: "plist")
            let dictionary = NSDictionary(contentsOfFile: path!)
            let domainName: AnyObject = dictionary?.object(forKey: "DomainName_Production") as AnyObject

            totalUrl = domainName + urlString
        #endif

        self.urlSession_libDelegate = currentView

        var request = URLRequest(url: URL(string: totalUrl)!)
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
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("HttpStatusCode : \(statusCode)")
                if statusCode == 200 {
                    let json = JSON(data: data)
                    print("\(json)")
                    self.urlSession_libDelegate?.UrlSessionBack_SuccessAction(urlSession_lib: urlSession_lib, currentView: currentView, json: json)
                }else{
                    self.urlSession_libDelegate?.UrlSessionBack_DataFailureAction(urlSession_lib: urlSession_lib, statusErrCode: statusCode, errType: "Serialize Error")
                }
            } else {
                self.urlSession_libDelegate?.UrlSessionBack_HttpFailureAction(errType: "Internet Error")
            }
        }
        task.resume()
    }
}
