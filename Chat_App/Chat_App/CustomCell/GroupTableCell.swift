//
//  GroupTableCell.swift
//  Chat_App
//
//  Created by Developer88 on 4/25/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
@objc protocol CheckedTableviewDelegate {
    @objc optional func SettingsDidSelectTableViewCell(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath, type: String)
}

class GroupTableCell: UITableViewCell {

    @IBOutlet var imgPerson: UIImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var btnRight: UIButton!
    
    var indexPath: IndexPath!
    var Celldelegate: CheckedTableviewDelegate!
    var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgPerson.layer.cornerRadius = imgPerson.frame.width / 2
        
        self.btnRight.layer.cornerRadius = btnRight.frame.width / 2
        self.btnRight.layer.borderWidth = 1
        self.btnRight.layer.borderColor = UIColor.gray.cgColor
    }

    func setUpCustom(tableView: UITableView, indexPath: IndexPath, CustomDelegate: CheckedTableviewDelegate) {
        self.Celldelegate = CustomDelegate
        self.indexPath = indexPath
        self.tableView = tableView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func handleBtnRight(_ sender: Any) {
        if btnRight.tag == 0 {
            btnRight.tag = 1
        self.btnRight.setImage(UIImage(named: "true"), for: .normal)
        Celldelegate.SettingsDidSelectTableViewCell?(tableView: self.tableView, didSelectRowAtIndexPath: self.indexPath, type: "Checked")
        } else {
            btnRight.tag = 0
            self.btnRight.setImage(UIImage(named: ""), for: .normal)
            Celldelegate.SettingsDidSelectTableViewCell?(tableView: self.tableView, didSelectRowAtIndexPath: self.indexPath, type: "unChecked")
        }
    }
}
