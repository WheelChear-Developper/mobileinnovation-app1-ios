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
    let base_config_instance = Configuration()
    // AppDelegateへのインスタンス
    let base_appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    // 通知用ライブラリのインスタンス
    let base_notification_lib = Notification_lib()

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

    override var prefersStatusBarHidden: Bool {
        return false
    }

    // Tabにカウントを設定する
    func base_tabIconCountSet(tabNo: Int, bage: String) {
        if let tabItem = self.tabBarController?.tabBar.items?[tabNo] {
            tabItem.badgeValue = bage
        }
    }

    // UrlSession後処理
    func UrlSessionBack_SuccessAction(urlSession_lib: UrlSession_lib, currentView: BaseViewController, dicJson: NSDictionary) {
    }
    func UrlSessionBack_DataFailureAction(urlSession_lib: UrlSession_lib, statusErrCode: Int, errType: String) {
    }
    func UrlSessionBack_HttpFailureAction(errType: String) {
    }
}
