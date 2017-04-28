//
//  ContactInfoController.swift
//  Chat_App
//
//  Created by Developer88 on 4/27/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class ContactInfoController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblvw: UITableView!
    var list = ["Media Links and Docs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblvw.delegate = self
        tblvw.dataSource = self
        tblvw.register(UINib(nibName: "contactInfoBottomCell", bundle: nil), forCellReuseIdentifier: "contactInfoBottomCell")
        tblvw.register(UINib(nibName: "ContactInfoCell", bundle: nil), forCellReuseIdentifier: "ContactInfoCell")
        tblvw.register(UINib(nibName: "statusCell", bundle: nil), forCellReuseIdentifier: "statusCell")
        self.title = "Contact Info"
        let editbtn = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit))
        self.navigationItem.rightBarButtonItem = editbtn
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0) {
            return 90
        } else if(indexPath.row == 2){
            return 146
        } else {
            return 48
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0) {
            let cell = tblvw.dequeueReusableCell(withIdentifier: "ContactInfoCell", for: indexPath) as!ContactInfoCell
            cell.imgvw.image = UIImage(named: "Gradient")
            cell.username.text = String(describing :ChatController.reciever_id!)
            return cell
        } else if(indexPath.row == 1) {
            let cell1 = tblvw.dequeueReusableCell(withIdentifier: "contactInfoBottomCell", for: indexPath) as! contactInfoBottomCell
            cell1.lbl.text = list[indexPath.row - 1]
            return cell1
        } else {
            let cell = self.tblvw.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath) as! statusCell
            cell.phonenumber.text = String(describing: ChatController.reciever_id!)
            cell.status.text = "Sample Status"
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func edit() {
        print("Edit profile controller")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
