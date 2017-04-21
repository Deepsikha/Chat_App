//
//  NewChatCell.swift
//  Chat_App
//
//  Created by devloper65 on 4/20/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class NewChatCell: UITableViewCell {

    @IBOutlet var imgContact: UIImageView!
    @IBOutlet var lblContact: UILabel!
    @IBOutlet var lblStatus: UILabel!
    
    @IBOutlet var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgContact.layer.borderWidth = 1
        self.imgContact.layer.borderColor = UIColor.black.cgColor
        self.imgContact.layer.cornerRadius = self.imgContact.frame.height / 2
    }
    
    override func prepareForReuse() {
        self.imgContact.image = nil
        self.lblStatus.text = nil
        self.lblContact.text = nil
        self.lblName.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
