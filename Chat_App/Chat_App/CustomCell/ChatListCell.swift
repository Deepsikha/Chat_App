//
//  ChatListCell.swift
//  Chat_App
//
//  Created by Developer88 on 4/20/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class ChatListCell: UITableViewCell {

    
    @IBOutlet weak var prflpic: UIImageView!
    @IBOutlet weak var msgstatus: UIImageView!
    @IBOutlet weak var cnctname: UILabel!
    @IBOutlet weak var lstmsg: UILabel!
    @IBOutlet weak var msgcount: UILabel!
    @IBOutlet weak var timestmp: UILabel!
    @IBOutlet weak var arrbtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prflpic.layer.cornerRadius = prflpic.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
