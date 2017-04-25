//
//  CallsController.swift
//  Chat_App
//
//  Created by Developer88 on 4/17/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class CallsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tblCalls: UITableView!
    @IBOutlet var lblNoti: UILabel!
    
    var callList:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNoti.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !(callList.isEmpty) {
            self.tblCalls.isHidden = false
            self.lblNoti.isHidden = true
            tblCalls.delegate = self
            tblCalls.dataSource = self
            
            self.tblCalls.register(UINib(nibName: "NewChatCell", bundle: nil), forCellReuseIdentifier: "NewChatCell")
        } else {
            self.tblCalls.isHidden = true
            self.lblNoti.isHidden = false
            self.view.backgroundColor = UIColor.groupTableViewBackground
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "Calls")
            attachment.bounds = CGRect(x: -10, y: -7 , width: 25, height: 25)
            let attachmentStr = NSAttributedString(attachment: attachment)
            let myString = NSMutableAttributedString(string: "To place WhatsApp call,open a chat and Tap ")
            myString.append(attachmentStr)
            let myString1 = NSMutableAttributedString(string: " at the top")
            myString.append(myString1)
            lblNoti.attributedText = myString
            
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !(callList.isEmpty) {
            return callList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : NewChatCell = tableView.dequeueReusableCell(withIdentifier: "NewChatCell", for: indexPath) as! NewChatCell
        
        return cell
    }

    

}
