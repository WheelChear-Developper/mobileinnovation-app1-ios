//
//  ViewController.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/11.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lbl_token: UILabel!

    override func viewDidLoad() {

        super.viewDidLoad()

        let config_instance = Configuration()
        lbl_token.text = config_instance.configurationGet_String(keyName: "DeviceToken")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

