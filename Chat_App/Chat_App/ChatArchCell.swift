//
//  ChatArchCell.swift
//  Chat_App
//
//  Created by Developer88 on 4/20/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class ChatArchCell: UITableViewCell {

    @IBOutlet weak var archvw: UIView!
    @IBOutlet weak var archcount: UILabel!
    @IBOutlet weak var srchbar: UISearchBar!
    @IBOutlet weak var brdcstlist: UIButton?
    @IBOutlet weak var newgrp: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        srchbar.showsCancelButton = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
