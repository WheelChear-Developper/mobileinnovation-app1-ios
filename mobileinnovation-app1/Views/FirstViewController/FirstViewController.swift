//
//  FirstViewController.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/15.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import UIKit
import LTMorphingLabel
import SwiftyJSON

class FirstViewController: BaseViewController {

    // UrlSession_libのインスタンス(apikeyget用)
    let urlSessionGetClient_apikeyget = UrlSession_lib()
    // UrlSession_libのインスタンス(apidevicetoken用)
    let urlSessionGetClient_apidevicetoken = UrlSession_lib()

    // Loading関連変数
    var timer: Timer!
    var loading_paternNo: Int!
    var loading_patern:[String]!

    // View
    @IBOutlet weak var lbl_Loading: LTMorphingLabel!
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var lbl_info1: UILabel!
    @IBOutlet weak var lbl_info2: UILabel!

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
        self.base_config_instance.configurationSet_String(value: "", keyName: "DeviceToken")
        #if (!arch(i386) && !arch(x86_64))
            // 実機

            // 起動ごとにDeviceToken取得
            self.base_appDelegate.setNotification()
        #else
            // シミュレータ時の仮DeviceToken設定
            self.base_config_instance.configurationSet_String(value: "ios_Emureter999999999999999999999999999999999999999999999999999999999999999", keyName: "DeviceToken")
        #endif

        // logoフェードイン
        lbl_info1.fadeIn(type: .Slow)
        lbl_info2.fadeIn(type: .Slow)
        lbl_info1.fadeIn(type: .Slow) { [weak self] in

            //APIKEY取得
            self?.getApi_akikey()
        }
    }

    func update(tm: Timer) {
        lbl_Loading.text = loading_patern[loading_paternNo]
        loading_paternNo = loading_paternNo + 1
        if loading_patern.count <= loading_paternNo {
            loading_paternNo = 0
        }
    }

    func getApi_akikey() {

        // 本体のAPP_CODE取得
        let path = Bundle.main.path(forResource: "propaty", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: path!)
        let appCode: AnyObject = dictionary?.object(forKey: "APP_CODE") as AnyObject

        // APIKEY取得
        urlSessionGetClient_apikeyget.post(urlSession_lib: urlSessionGetClient_apikeyget, currentView: self, url: "/api/apikey_get", parameters: ["app_code": appCode])
    }

    func setApi_devicetoken() {

        // 本体のAPP_CODE取得
        let path = Bundle.main.path(forResource: "propaty", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: path!)
        let appCode: AnyObject = dictionary?.object(forKey: "APP_CODE") as AnyObject

        #if DEBUG
            // APIKEY取得
            urlSessionGetClient_apidevicetoken.post(urlSession_lib: urlSessionGetClient_apidevicetoken, currentView: self, url: "/api/notification/token_post", parameters: ["app_code": appCode, "device_token": self.base_config_instance.configurationGet_String(keyName: "DeviceToken"), "device_type": "iOS_Staging"])
        #elseif STAGING
            // APIKEY取得
            urlSessionGetClient_apidevicetoken.post(urlSession_lib: urlSessionGetClient_apidevicetoken, currentView: self, url: "/api/notification/token_post", parameters: ["app_code": appCode, "device_token": self.base_config_instance.configurationGet_String(keyName: "DeviceToken"), "device_type": "iOS_Staging"])
        #else
            // APIKEY取得
            urlSessionGetClient_apidevicetoken.post(urlSession_lib: urlSessionGetClient_apidevicetoken, currentView: self, url: "/api/notification/token_post", parameters: ["app_code": appCode, "device_token": self.base_config_instance.configurationGet_String(keyName: "DeviceToken"), "device_type": "iOS"])
        #endif
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // UrlSession_lib processing
    override func UrlSessionBack_SuccessAction(urlSession_lib: UrlSession_lib, currentView: BaseViewController, json: JSON) {

        if urlSession_lib == urlSessionGetClient_apikeyget {

            // ApiKey ローカル保存
            let dic = json["apikey"].string
            self.base_config_instance.configurationSet_String(value: dic!, keyName: "ApiKey")
            print("apikey = " + self.base_config_instance.configurationGet_String(keyName: "ApiKey"))

            // DeviceTokenチェック
            while true {
                if self.base_config_instance.configurationGet_String(keyName: "DeviceToken") != "" {
                    break
                }
            }

            // DeviceToken登録
            self.setApi_devicetoken()
        }

        if urlSession_lib == urlSessionGetClient_apidevicetoken {

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
