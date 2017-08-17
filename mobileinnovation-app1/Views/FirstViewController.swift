//
//  FirstViewController.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/15.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import UIKit
import LTMorphingLabel

class FirstViewController: BaseViewController {

    // UrlSession_libのインスタンス(apikeyget用)
    let urlSessionGetClient_apikeyget = UrlSession_lib()

    // Loading関連変数
    var timer: Timer!
    var loading_paternNo: Int!
    var loading_patern:[String]!

    // View
    @IBOutlet weak var lbl_Loading: LTMorphingLabel!
    @IBOutlet weak var img_logo: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        lbl_Loading.morphingEffect = .sparkle
        loading_paternNo = 0
        loading_patern = ["L", "Lo", "Loa", "Load", "Loadi", "Loadin", "Loading", "Loading ", "Loading N", "Loading No", "Loading Now"]

        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timer.fire()

        // DeviceToken 初期化
        config_instance.configurationSet_String(value: "", keyName: "DeviceToken")
        // 起動ごとにDeviceToken取得
        appDelegate.setNotification()

        // logoフェードイン
        img_logo.fadeIn(type: .Slow)
        img_logo.fadeIn(type: .Slow) { [weak self] in

            //APIKEY取得
            self?.getApi_akikey()
        }

        //        lbl_token.text = config_instance.configurationGet_String(keyName: "DeviceToken")

        //        let queryItems = [URLQueryItem(name: "a", value: "foo"),
        //                          URLQueryItem(name: "b", value: "1234")]
        //        urlSessionGetClient.get(currentView: self, url: "http://192.168.0.170:8000/api/json_notice_list/", queryItems: nil, session: urlSessionGetClient)


        //        lbl_token.text = config_instance.configurationGet_String(keyName: "DeviceToken")
    }

    func update(tm: Timer) {
        lbl_Loading.text = loading_patern[loading_paternNo]
        loading_paternNo = loading_paternNo + 1
        if loading_patern.count <= loading_paternNo {
            loading_paternNo = 0
        }
    }

    func getApi_akikey() {

        // APIKEY取得
        urlSessionGetClient_apikeyget.post(urlSession_lib: urlSessionGetClient_apikeyget, currentView: self, url: "http://192.168.0.170:8000/api/apikey_get/", parameters: ["app_code": "APP_fGsIk7S3SSi"])
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

            // DeviceTokenチェック
            while true {
                if config_instance.configurationGet_String(keyName: "DeviceToken") != "" {
                    break
                }
            }

            // タイマーストップ
            timer.invalidate()

            // 画面遷移
            let next = storyboard!.instantiateViewController(withIdentifier: "MainNavigation")
            self.present(next,animated: true, completion: nil)
        }
    }
    override func UrlSessionBack_DataFailureAction(urlSession_lib: UrlSession_lib, statusErrCode: Int, errType: String) {

        if urlSession_lib == urlSessionGetClient_apikeyget {

            let alert = UIAlertController(
                title: "エラー",
                message: "通信に失敗しました。電波条件の良い場所で再度お試しください。(エラーコード：\(statusErrCode))",
                preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                //APIKEY取得
                self.getApi_akikey()
            }))

            self.present(alert, animated: true, completion: nil)
        }
    }
    override func UrlSessionBack_HttpFailureAction(errType: String) {

        let alert = UIAlertController(
            title: "エラー",
            message: "通信に失敗しました。電波条件の良い場所で再度お試しください。",
            preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            //APIKEY取得
            self.getApi_akikey()
        }))

        self.present(alert, animated: true, completion: nil)
    }
}
