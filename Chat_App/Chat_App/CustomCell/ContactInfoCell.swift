//
//  ContactInfoCell.swift
//  Chat_App
//
//  Created by Developer88 on 4/28/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class ContactInfoCell: UITableViewCell {

    @IBOutlet weak var imgvw: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgvw.layer.cornerRadius = self.imgvw.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
