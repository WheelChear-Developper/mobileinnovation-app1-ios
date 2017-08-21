//
//  Tab3_TableViewCell.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/21.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import UIKit

class Tab3_TableViewCell: UITableViewCell {

    @IBOutlet weak var image_photo: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var txt_message: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
