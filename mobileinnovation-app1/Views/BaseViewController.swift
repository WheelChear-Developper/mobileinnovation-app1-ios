//
//  BaseViewController.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/15.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UrlSession_libDelegate {

    // Congigrationのインスタンス
    let config_instance = Configuration()
    // UrlSession=libのインスタンス
    let urlSessionGetClient = UrlSession_lib()

    override func viewDidLoad() {

        super.viewDidLoad()


//        lbl_token.text = config_instance.configurationGet_String(keyName: "DeviceToken")

        //        let queryItems = [URLQueryItem(name: "a", value: "foo"),
        //                          URLQueryItem(name: "b", value: "1234")]
        //        urlSessionGetClient.get(currentView: self, url: "http://192.168.0.170:8000/api/json_notice_list/", queryItems: nil, session: urlSessionGetClient)

        urlSessionGetClient.post(currentView: self, url: "http://192.168.0.170:8000/api/apikey_get/", parameters: ["app_code": "APP_fGsIk7S3SSi"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func UrlSessionBack_SuccessAction(dicJson: NSDictionary) {

        let dic = dicJson["apikey"]
        config_instance.configurationSet_String(token: dic as! String, keyName: "apikey")
    }
    func UrlSessionBack_DataFailureAction(errType: String) {
    }
    func UrlSessionBack_HttpFailureAction(errCode: uint) {
    }
    
}
