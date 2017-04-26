//
//  GroupAddCell.swift
//  Chat_App
//
//  Created by Developer88 on 4/25/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class GroupAddCell: UICollectionViewCell {

    @IBOutlet var imgpic: UIImageView!
    @IBOutlet var lblName: UILabel!
    
    @IBOutlet var btnCancel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgpic.layer.cornerRadius = imgpic.frame.width / 2
        self.imgpic.layer.borderColor = UIColor.blue.cgColor
        self.imgpic.layer.borderWidth = 1

        // Initialization code
    }

}
