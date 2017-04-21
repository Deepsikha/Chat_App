//
//  CountryCell.swift
//  Chat_App
//
//  Created by devloper65 on 4/19/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {

    
    @IBOutlet var lblCountryName: UILabel!
    @IBOutlet var lblCountryCode: UILabel!
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
