//
//  ViewController.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/11.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UrlSession_libDelegate {

    @IBOutlet weak var lbl_token: UILabel!

    let urlSessionGetClient = UrlSession_lib()

    var urlSession_libDelegate:UrlSession_libDelegate?


    override func viewDidLoad() {

        super.viewDidLoad()

        let config_instance = Configuration()
        lbl_token.text = config_instance.configurationGet_String(keyName: "DeviceToken")

        let queryItems = [URLQueryItem(name: "a", value: "foo"),
                          URLQueryItem(name: "b", value: "1234")]
        urlSessionGetClient.get(currentView: self, url: "http://192.168.0.170:8000/api/json_notice_list/", queryItems: nil, session: urlSessionGetClient)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func UrlSessionBack_SuccessAction() {

    }
    func UrlSessionBack_DataFailureAction(errType: String) {

    }
    func UrlSessionBack_HttpFailureAction(errCode: uint) {

    }

}

