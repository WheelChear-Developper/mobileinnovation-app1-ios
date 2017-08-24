//
//  Tab5_ViewController.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/17.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import UIKit

class Tab5_ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var settingTableview: UITableView!
    var int_setting_boardTableRow: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // ステータスバー背景色設定
        self.base_setStatusBarBackgroundColor(color: #colorLiteral(red: 0.2549019608, green: 0.3490196078, blue: 0.5411764706, alpha: 1))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // NavigationBarを非表示にしたい場合
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        settingTableview.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    ///////////////////////////////////////////////// Table Method Groupe ////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if indexPath.row == 0 {

            cell = tableView.dequeueReusableCell(withIdentifier: "Finger") as! Tab5_TableViewCell

            return cell!
        }

        return cell!
    }

    @objc func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // 行設定
        int_setting_boardTableRow = indexPath.row

        performSegue(withIdentifier: "infomatinSub",sender: nil)
    }
    ///////////////////////////////////////////////// Table Method Groupe ////////////////////////////////////////////////////////////////

}
