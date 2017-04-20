//
//  NewChatHeaderCell.swift
//  Chat_App
//
//  Created by devloper65 on 4/20/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class NewChatHeaderCell: UITableViewCell {

    @IBOutlet var btn: UIButton!
    @IBOutlet var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.img.backgroundColor = UIColor.groupTableViewBackground
        self.img.layer.cornerRadius = self.img.frame.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
