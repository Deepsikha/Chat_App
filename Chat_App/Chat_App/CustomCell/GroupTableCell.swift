//
//  GroupTableCell.swift
//  Chat_App
//
//  Created by Developer88 on 4/25/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class GroupTableCell: UITableViewCell {

    @IBOutlet var imgPerson: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgRight: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
