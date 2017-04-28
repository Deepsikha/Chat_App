//
//  statusCell.swift
//  Chat_App
//
//  Created by Developer88 on 4/28/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class statusCell: UITableViewCell {

    @IBOutlet weak var phonenumber: UILabel!
    @IBOutlet weak var status: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func openchat(_ sender: Any) {
        
    }
    
    @IBAction func startvideocall(_ sender: Any) {
    }
    
    @IBOutlet weak var startvoicecall: UIButton!
    
    
}
