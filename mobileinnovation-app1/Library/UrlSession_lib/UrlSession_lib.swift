//
//  UrlSession_lib.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/14.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import Foundation

protocol UrlSession_libDelegate {
    func UrlSessionBack_SuccessAction()
    func UrlSessionBack_DataFailureAction(errType: String)
    func UrlSessionBack_HttpFailureAction(errCode: uint)
}

class UrlSession_lib:NSObject {

    var urlSession_libDelegate:UrlSession_libDelegate?

    func get(currentView: ViewController, url urlString: String, queryItems: [URLQueryItem]? = nil, session: UrlSession_lib) {

        self.urlSession_libDelegate = currentView

        var compnents = URLComponents(string: urlString)
        compnents?.queryItems = queryItems
        let url = compnents?.url
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let data = data, let response = response {
                print(response)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)
                    self.urlSession_libDelegate?.UrlSessionBack_SuccessAction()
                } catch {
                    print("Serialize Error")
                    self.urlSession_libDelegate?.UrlSessionBack_DataFailureAction(errType: "Serialize Error")
                }
            } else {
                print(error ?? "Error")
                self.urlSession_libDelegate?.UrlSessionBack_HttpFailureAction(errCode: error as! uint)
            }
        }

        task.resume()
    }
}
