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
import CircularSpinner
import SCLAlertView

class Tab3_ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    // UrlSession_libのインスタンス(apikeyget用)
    let urlSessionGetClient_jsonNoticeList = UrlSession_lib()

    @IBOutlet weak var notice_boardTableview: UITableView!
    var json_Data: JSON = []
    var int_notice_boardTableRow: Int!

    // 縦文字のVIEW
    @IBOutlet weak var view_moji1_back: UIView!
    @IBOutlet weak var view_moji2_back: UIView!
    
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
        view_moji2_back.backgroundColor = UIColor(patternImage: UIImage(named: "back2.png")!)

        // TableviewCell設定
        notice_boardTableview.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // NavigationBarを非表示にしたい場合
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        // 文字アニメーション設定
        lbl_animation.morphingEffect = .scale
        int_count_lbl_animation = 0
        patern_lbl_animation = ["公式アプリをリリースしました", "スマホアプリを開発しています", "このアプリでもいろいろな機能をご確認下さい", "FacebookなどのSNSでも公開しています", "SNSからご相談お待ちしています"]
        timer_lbl_animation = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.update_lbl_animation), userInfo: nil, repeats: true)
        timer_lbl_animation.fire()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Loading表示設定
//        CircularSpinner.show("Loading...", animated: true, type: .indeterminate)

        // API_最新情報取得
        self.getNotice_list()

        // Loading非表示
//        CircularSpinner.hide()

        // Tableview更新
        self.notice_boardTableview.reloadData()
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

    // API_最新情報取得
    func getNotice_list() {

        urlSessionGetClient_jsonNoticeList.get(urlSession_lib: urlSessionGetClient_jsonNoticeList, currentView: self, url: "/api/json_notice_list/")
        
    }

    // 文字アニメーション用タイマーセレクター
    func update_lbl_animation(tm: Timer) {
        lbl_animation.text = patern_lbl_animation[int_count_lbl_animation]
        int_count_lbl_animation = int_count_lbl_animation + 1
        if patern_lbl_animation.count <= int_count_lbl_animation {
            int_count_lbl_animation = 0
        }
    }

    ///////////////////////////////////////////////// Table Method Groupe ////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return json_Data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Tab3_TableViewCell_1") as! Tab3_TableViewCell

        cell.selectionStyle = UITableViewCellSelectionStyle.none

        // セルに値を設定
        let image: String = json_Data[indexPath.row]["image"].string!
        let title: String = json_Data[indexPath.row]["title"].string!
        let message: String = json_Data[indexPath.row]["message"].string!
        cell.lbl_title.text = title
        cell.lbl_message.text = message

        cell.image_photo.image = nil
        if image != "" {

            let req = URLRequest(url: NSURL(string:UrlSession_lib().getDomain() + "/static/notice_board/images/" + image)! as URL,
                                 cachePolicy: .returnCacheDataElseLoad,
                                 timeoutInterval: 5 * 60);
            let conf =  URLSessionConfiguration.default;
            let session = URLSession(configuration: conf, delegate: nil, delegateQueue: OperationQueue.main);

            session.dataTask(with: req, completionHandler:
                { (data, resp, err) in
                    if((err) == nil){ //Success
                        let image = UIImage(data:data!)
                        cell.image_photo.image = image;

                    }else{ //Error
                        print("AsyncImageView:Error \(String(describing: err?.localizedDescription))");
                    }
            }).resume();
            
        }else{
            
            cell.image_photo.image = UIImage(named:"company_icon_logo.png")!
        }
        return cell
    }

    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

//        SCLAlertView().showInfo("infomation", subTitle: "subTitle")

        // 行設定
        int_notice_boardTableRow = indexPath.row

        performSegue(withIdentifier: "infomatinSub",sender: nil)
    }
    ///////////////////////////////////////////////// Table Method Groupe ////////////////////////////////////////////////////////////////

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "infomatinSub" {

            let infomation = segue.destination as! Tab3_Infomation_ViewController
            infomation.para_str_image = json_Data[int_notice_boardTableRow]["image"].string!
            infomation.para_str_title = json_Data[int_notice_boardTableRow]["title"].string!
            infomation.para_str_message = json_Data[int_notice_boardTableRow]["message"].string!
        }
    }


    // UrlSession_lib processing
    override func UrlSessionBack_SuccessAction(urlSession_lib: UrlSession_lib, json: JSON) {

        if urlSession_lib == urlSessionGetClient_jsonNoticeList {

            self.json_Data = json["notices"]

            // APIからの遅延処理
            DispatchQueue.main.async(execute: {

                self.notice_boardTableview.reloadData()
            })
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

