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

    override func viewDidLoad() {

        super.viewDidLoad()
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