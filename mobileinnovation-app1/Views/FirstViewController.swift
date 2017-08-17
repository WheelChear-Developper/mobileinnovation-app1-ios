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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // 起動ごとにDeviceToken取得
        appDelegate.setNotification()

        //APIKEY取得
        urlSessionGetClient_apikeyget.post(urlSession_lib: urlSessionGetClient_apikeyget, currentView: self, url: "http://192.168.0.170:8000/api/apikey_get/", parameters: ["app_code": "APP_fGsIk7S3SSi"])

        //        lbl_token.text = config_instance.configurationGet_String(keyName: "DeviceToken")

        //        let queryItems = [URLQueryItem(name: "a", value: "foo"),
        //                          URLQueryItem(name: "b", value: "1234")]
        //        urlSessionGetClient.get(currentView: self, url: "http://192.168.0.170:8000/api/json_notice_list/", queryItems: nil, session: urlSessionGetClient)


        lbl_token.text = config_instance.configurationGet_String(keyName: "DeviceToken")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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

        let alert = UIAlertController(
            title: "エラー",
            message: "通信に失敗しました。電波条件の良い場所で再度お試しください。",
            preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.viewDidAppear(false)
        }))

        self.present(alert, animated: true, completion: nil)
    }
}
