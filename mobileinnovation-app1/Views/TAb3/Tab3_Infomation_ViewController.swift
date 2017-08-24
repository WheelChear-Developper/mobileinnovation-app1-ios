//
//  Tab3_Infomation_ViewController.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/23.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import UIKit

class Tab3_Infomation_ViewController: UIViewController {

    @IBOutlet weak var img_photo: AsyncImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_message: UILabel!

    var para_str_image: String!
    var para_str_title: String!
    var para_str_message: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // NavigationBarを表示したい場合
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        // Controllerのタイトルを設定する.
        self.title = "最新情報"

        // Viewの背景色を定義する.
        self.view.backgroundColor = #colorLiteral(red: 0.2549019608, green: 0.3490196078, blue: 0.5411764706, alpha: 1)

        self.lbl_title.text = para_str_title
        self.lbl_message.text = para_str_message

        if para_str_image != "" {

            self.img_photo.loadImage(urlString: HttpRequestController().getDomain() + "/static/notice_board/images/" + para_str_image)
        }else{

            self.img_photo.image = UIImage(named:"company_icon_logo.png")!
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
