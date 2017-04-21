//
//  StatusController.swift
//  Chat_App
//
//  Created by Developer88 on 4/17/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class StatusController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblStatus: UITableView!
    @IBOutlet var vwHeader: UIView!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var btnPrivacy: UIButton!
    
    var status:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tblStatus.delegate = self
        tblStatus.dataSource = self
        self.tblStatus.tableHeaderView = self.vwHeader
        
        tblStatus.register(UINib(nibName: "NewChatCell", bundle: nil), forCellReuseIdentifier: "NewChatCell")
    }
    
    override func viewDidLayoutSubviews() {
        self.btnPrivacy.layer.cornerRadius = 8
    }
    
    //MARK:- Table Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        } else {
            if status.isEmpty {
                return 1
            } else {
                return status.count

            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NewChatCell = (tableView.dequeueReusableCell(withIdentifier: "NewChatCell", for: indexPath) as? NewChatCell)!
        if indexPath.section == 0 {
            cell.lblName.isHidden = true
            cell.lblContact.isHidden = false
            cell.lblStatus.isHidden = false
            
            cell.imageView?.backgroundColor = UIColor.groupTableViewBackground
            cell.lblContact.text = "My Status"
            cell.lblStatus.text = "Add to my status"
            cell.lblStatus.textColor = UIColor.lightGray
            
            return cell
        } else {
            cell.lblName.isHidden = false
            cell.lblContact.isHidden = true
            cell.lblStatus.isHidden = true
            if status.isEmpty {
                cell.lblName.text = "WhatsApp"
                cell.lblName.textColor = UIColor.green
                cell.imgContact.image = UIImage(named: "Gradient.png")
            } else {
                cell.lblName.text = self.status[indexPath.row]
                cell.imgContact.image = UIImage(named: "Gradient.png")
            }
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "RECENT UPDATES"
        } else {
            return " "
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return " "
        } else {
            return ""
        }
    }
    
    //MARK:- Outlet Mwethod
    @IBAction func handleBtnCancel(_ sender: Any) {
        self.tblStatus.tableHeaderView = nil
    }
    
    @IBAction func handleBtnPrivacy(_ sender: Any) {
    }
    
    //MARK:- Custom Method
    
    func privacy() {
        
    }

}
