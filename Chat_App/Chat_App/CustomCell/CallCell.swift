//
//  CallCell.swift
//  Chat_App
//
//  Created by devloper65 on 4/25/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class CallCell: UITableViewCell {

    @IBOutlet var imgCall: UIImageView!
    @IBOutlet var btnCall: UIButton!
    @IBOutlet var lblCallPerson: UILabel!
    @IBOutlet var lblLastCallStatus: UILabel!
    @IBOutlet var imgCalltype: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
