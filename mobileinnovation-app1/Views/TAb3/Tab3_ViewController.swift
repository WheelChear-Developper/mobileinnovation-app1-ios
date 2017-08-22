//
//  Tab3_ViewController.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/17.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import UIKit
import SwiftyJSON
import NVActivityIndicatorView
import LTMorphingLabel

class Tab3_ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    // UrlSession_libのインスタンス(apikeyget用)
    let urlSessionGetClient_jsonNoticeList = UrlSession_lib()

    @IBOutlet weak var notice_boardTableview: UITableView!
    var json_Data: JSON = []

    // NVActivityIndicatorView　インスタンス
    @IBOutlet weak var activeIndicatorView: NVActivityIndicatorView!
    @IBOutlet weak var view_loading: UIView!

    // 縦文字のVIEW
    @IBOutlet weak var view_moji1_back: UIView!
    
    // 文字アニメーション
    @IBOutlet weak var lbl_animation: LTMorphingLabel!
    var timer_lbl_animation: Timer!
    var int_count_lbl_animation: Int!
    var patern_lbl_animation:[String]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // ステータスバー背景色設定
        self.base_setStatusBarBackgroundColor(color: #colorLiteral(red: 0.2549019608, green: 0.3490196078, blue: 0.5411764706, alpha: 1))

        // 縦文字の背景設定
        view_moji1_back.backgroundColor = UIColor(patternImage: UIImage(named: "back1.png")!)

        // TableviewCell設定
        notice_boardTableview.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // 文字アニメーション設定
        lbl_animation.morphingEffect = .scale
        int_count_lbl_animation = 0
        patern_lbl_animation = ["公式アプリをリリースしました。", "スマホアプリを開発しています。", "FacebookなどのSNSでも情報公開しています"]
        timer_lbl_animation = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.update_lbl_animation), userInfo: nil, repeats: true)
        timer_lbl_animation.fire()

        // Loading表示設定
        self.setLoading()

        // APIKEY取得
        urlSessionGetClient_jsonNoticeList.get(urlSession_lib: urlSessionGetClient_jsonNoticeList, currentView: self, url: "/api/json_notice_list/")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // タイマーストップ
        timer_lbl_animation.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // 文字アニメーション用タイマーセレクター
    func update_lbl_animation(tm: Timer) {
        lbl_animation.text = patern_lbl_animation[int_count_lbl_animation]
        int_count_lbl_animation = int_count_lbl_animation + 1
        if patern_lbl_animation.count <= int_count_lbl_animation {
            int_count_lbl_animation = 0
        }
    }

    // ローディング表示設定
    func setLoading() {
        view_loading.isHidden = false
        activeIndicatorView.startAnimating()
    }
    func unsetLoading() {
        view_loading.isHidden = true
        activeIndicatorView.stopAnimating()
    }

    ///////////////////////////////////////////////// Table Method Groupe ////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return json_Data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Tab3_TableViewCell_1") as! Tab3_TableViewCell

        // セルに値を設定
        let image: String = json_Data[indexPath.row]["image"].string!
        let title: String = json_Data[indexPath.row]["title"].string!
        let message: String = json_Data[indexPath.row]["message"].string!
        cell.lbl_title.text = title
        cell.lbl_message.text = message

        cell.image_photo.image = nil
        if image != "" {

            #if DEBUG
                // 本体のAPP_CODE取得
                let path = Bundle.main.path(forResource: "propaty", ofType: "plist")
                let dictionary = NSDictionary(contentsOfFile: path!)
                let domainName: AnyObject = dictionary?.object(forKey: "DomainName_Staging") as AnyObject
            #elseif STAGING
                // 本体のAPP_CODE取得
                let path = Bundle.main.path(forResource: "propaty", ofType: "plist")
                let dictionary = NSDictionary(contentsOfFile: path!)
                let domainName: AnyObject = dictionary?.object(forKey: "DomainName_Production") as AnyObject
            #else
                // 本体のAPP_CODE取得
                let path = Bundle.main.path(forResource: "propaty", ofType: "plist")
                let dictionary = NSDictionary(contentsOfFile: path!)
                let domainName: AnyObject = dictionary?.object(forKey: "DomainName_Production") as AnyObject
            #endif

            cell.image_photo.loadImage(urlString: (domainName as! String) + "/static/notice_board/images/" + image)
        }else{

            cell.image_photo.image = UIImage(named:"company_icon_logo.png")!
        }
        
        return cell
    }
    ///////////////////////////////////////////////// Table Method Groupe ////////////////////////////////////////////////////////////////

    // UrlSession_lib processing
    override func UrlSessionBack_SuccessAction(urlSession_lib: UrlSession_lib, currentView: BaseViewController, json: JSON) {

        if urlSession_lib == urlSessionGetClient_jsonNoticeList {

            // Loading非表示
            self.unsetLoading()

            json_Data = json["notices"]
            notice_boardTableview.reloadData()
        }
    }
    override func UrlSessionBack_DataFailureAction(urlSession_lib: UrlSession_lib, statusErrCode: Int, errType: String) {

        if urlSession_lib == urlSessionGetClient_jsonNoticeList {

            let alert = UIAlertController(
                title: "エラー",
                message: "通信に失敗しました。電波条件の良い場所で再度お試しください。(エラーコード：\(statusErrCode))",
                preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

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

        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

