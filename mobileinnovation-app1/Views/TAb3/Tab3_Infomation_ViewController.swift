//
//  Tab3_Infomation_ViewController.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/23.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import UIKit

class Tab3_Infomation_ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // NavigationBarを表示したい場合
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        // Controllerのタイトルを設定する.
        self.title = "My Second View"

        // Viewの背景色を定義する.
        self.view.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.3490196078, blue: 0.5411764706, alpha: 1)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
