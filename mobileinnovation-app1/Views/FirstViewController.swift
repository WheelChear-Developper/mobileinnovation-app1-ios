//
//  FirstViewController.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/15.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import UIKit

class FirstViewController: BaseViewController {

    // UrlSession_libのインスタンス(apikeyget用)
    let urlSessionGetClient_apikeyget = UrlSession_lib()

    @IBOutlet weak var lbl_token: UILabel!

    override func viewDidLoad() {

        super.viewDidLoad()

        // 通信状態確認
        let reachability = AMReachability()
        if (reachability?.isReachable)! {
            print("インターネット接続あり")
        } else {
            print("インターネット接続なし")
        }

        // Congigrationのインスタンス
        let config_instance = Configuration()
        // ApiKey 初期化
        config_instance.configurationSet_String(value: "", keyName: "ApiKey")
        // DeviceToken 初期化
        config_instance.configurationSet_String(value: "", keyName: "DeviceToken")

        lbl_token.text = config_instance.configurationGet_String(keyName: "DeviceToken")

        // 起動ごとにDeviceToken取得
        appDelegate.setNotification()

        //APIKEY取得
        urlSessionGetClient_apikeyget.post(urlSession_lib: urlSessionGetClient_apikeyget, currentView: self, url: "http://192.168.0.170:8000/api/apikey_get/", parameters: ["app_code": "APP_fGsIk7S3SSi"])

        //        lbl_token.text = config_instance.configurationGet_String(keyName: "DeviceToken")

        //        let queryItems = [URLQueryItem(name: "a", value: "foo"),
        //                          URLQueryItem(name: "b", value: "1234")]
        //        urlSessionGetClient.get(currentView: self, url: "http://192.168.0.170:8000/api/json_notice_list/", queryItems: nil, session: urlSessionGetClient)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func UrlSessionBack_SuccessAction(urlSession_lib: UrlSession_lib, currentView: BaseViewController, dicJson: NSDictionary) {

        if urlSession_lib == urlSessionGetClient_apikeyget {

            // ApiKey ローカル保存
            let dic = dicJson["apikey"]
            config_instance.configurationSet_String(value: dic as! String, keyName: "ApiKey")
            print("apikey = " + config_instance.configurationGet_String(keyName: "ApiKey"))
        }
    }
    override func UrlSessionBack_DataFailureAction(statusErrCode: Int, errType: String) {
        print("HttpStatusErr:\(statusErrCode) ErrType\(errType)")
    }
    override func UrlSessionBack_HttpFailureAction(errType: String) {
        print(errType)
    }
}
