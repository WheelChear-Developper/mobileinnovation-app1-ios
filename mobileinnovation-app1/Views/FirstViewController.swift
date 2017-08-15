//
//  FirstViewController.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/15.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import UIKit

class FirstViewController: BaseViewController {

    @IBOutlet weak var lbl_token: UILabel!

    override func viewDidLoad() {

        super.viewDidLoad()

        lbl_token.text = config_instance.configurationGet_String(keyName: "DeviceToken")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func UrlSessionBack_SuccessAction(dicJson: NSDictionary) {
        super.UrlSessionBack_SuccessAction(dicJson: dicJson)

        

    }
    override func UrlSessionBack_DataFailureAction(errType: String) {
        super.UrlSessionBack_DataFailureAction(errType: errType)
        
    }
    override func UrlSessionBack_HttpFailureAction(errCode: uint) {
        super.UrlSessionBack_HttpFailureAction(errCode: errCode)
        
    }
    
}
