//
//  CallsController.swift
//  Chat_App
//
//  Created by Developer88 on 4/17/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import SDWebImage

class CallsController: UIViewController, UITableViewDelegate, UITableViewDataSource, SDWebImageManagerDelegate {

    @IBOutlet var tblCalls: UITableView!
    @IBOutlet var lblNoti: UILabel!
    
    var callList: NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNoti.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.callList = ModelManager.getInstance().getList()
        
        if !(callList.count == 0) {
            self.tblCalls.isHidden = false
            self.lblNoti.isHidden = true
            tblCalls.delegate = self
            tblCalls.dataSource = self
            
            self.tblCalls.register(UINib(nibName: "CallCell", bundle: nil), forCellReuseIdentifier: "CallCell")
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
        if !(callList.count == 0) {
            return callList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CallCell = tableView.dequeueReusableCell(withIdentifier: "CallCell", for: indexPath) as! CallCell
        let a = (callList.object(at: indexPath.row) as AnyObject)
        let url = server_API.Base_url.appending(String(describing: (a as AnyObject).value(forKey: "profile_pic") as! String))
        
        cell.imgCall.sd_setImage(with: URL(string: url), placeholderImage: nil, options: SDWebImageOptions.scaleDownLargeImages, completed: { (image, error, memory, imageUrl) in
        })
        cell.lblCallPerson.text = (a.value(forKey: "username")! as! String)
        
        return cell
    }
}
