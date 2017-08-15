//
//  UrlSession_lib.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/14.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import Foundation

protocol UrlSession_libDelegate {
    func UrlSession_BackAction()
}

class UrlSession_lib:NSObject {

    var urlSession_libDelegate:UrlSession_libDelegate?

    func get(url urlString: String, queryItems: [URLQueryItem]? = nil, session: UrlSession_lib) {
        var compnents = URLComponents(string: urlString)
        compnents?.queryItems = queryItems
        let url = compnents?.url
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let data = data, let response = response {
                print(response)
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    print(json)

//                    self.URLSessionGetClient_back()
                } catch {
                    print("Serialize Error")
                }
            } else {
                print(error ?? "Error")
            }
        }

        task.resume()
    }

    func UrlSession_lib_Test(currentView: ViewController) {

        print(currentView)

        self.urlSession_libDelegate?.UrlSession_BackAction()
    }
}
