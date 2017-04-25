//
//  ChatArchCell.swift
//  Chat_App
//
//  Created by Developer88 on 4/20/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class ChatArchCell: UITableViewCell, UISearchBarDelegate {

    @IBOutlet weak var archvw: UIView!
    @IBOutlet weak var archcount: UILabel!
    @IBOutlet weak var srchbar: UISearchBar!
    @IBOutlet weak var brdcstlist: UIButton?
    @IBOutlet weak var newgrp: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        srchbar.delegate = self
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        srchbar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        srchbar.showsCancelButton = false
        srchbar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(srchbar.text?.isEmpty)! {
        
        } else {
        
        }
    }
    
    @IBAction func newgroup(_ sender: Any) {
        NotificationCenter.default.post(name: (name: NSNotification.Name(rawValue : "push")) as! NSNotification.Name, object: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
