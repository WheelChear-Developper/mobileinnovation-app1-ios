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
    // AppDelegateへのインスタンス
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    // 通知用ライブラリのインスタンス
    let notification_lib = Notification_lib()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func UrlSessionBack_SuccessAction(urlSession_lib: UrlSession_lib, currentView: BaseViewController, dicJson: NSDictionary) {
    }
    func UrlSessionBack_DataFailureAction(statusErrCode: Int, errType: String) {
    }
    func UrlSessionBack_HttpFailureAction(errType: String) {
    }
}
