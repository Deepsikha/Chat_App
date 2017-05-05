//
//  SenderCell.swift
//  Chat_App
//
//  Created by Developer88 on 4/19/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class SenderCell: UITableViewCell {

    @IBOutlet weak var profilePic : UIImageView!
    @IBOutlet weak var message: UITextView!
    @IBOutlet weak var messageBackground: UIImageView!
    
    func clearCellData()  {
        self.message.text = nil
        self.message.isHidden = false
        self.messageBackground.image = nil

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.message.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        self.messageBackground.layer.cornerRadius = 15
        self.messageBackground.clipsToBounds = true
    }
    
    
    
}
