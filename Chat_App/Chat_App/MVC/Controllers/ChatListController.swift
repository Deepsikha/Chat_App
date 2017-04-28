//
//  ChatListController.swift
//  Chat_App
//
//  Created by Developer88 on 4/20/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class ChatListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblvw: UITableView!
    
    static var sender = 0
    var contactNumber : NSMutableArray!
    var last = [String]()
    var msgCount: [Int]! = []
    var latest : NSMutableArray!
    static var searchText : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countmsg()
        tblvw.delegate = self
        tblvw.dataSource = self
        self.navigationController?.isToolbarHidden = true
        tblvw.register(UINib(nibName: "ChatArchCell", bundle: nil), forCellReuseIdentifier: "ChatArchCell")
        tblvw.register(UINib(nibName: "ChatListCell", bundle: nil), forCellReuseIdentifier: "ChatListCell")
        NotificationCenter.default.addObserver(self, selector: #selector(countmsg), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(push), name: NSNotification.Name(rawValue: "push"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(filterContentForSearchText), name: NSNotification.Name(rawValue : "search"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(typing(_:)), name: NSNotification.Name(rawValue : "type"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        countmsg()
        
    }
    
    //MARK: Table Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactNumber.count + 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0) {
            return 143
        } else {
            return 60
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if(indexPath.row == 0) {
            let cell = tblvw.dequeueReusableCell(withIdentifier: "ChatArchCell", for: indexPath) as! ChatArchCell
            return cell
        } else {
            
            let contact = contactNumber.object(at: indexPath.row - 1) as! (Any,Any)
            let cell = tblvw.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath) as! ChatListCell
            cell.prflpic.image = UIImage(named : "Gradient")
            let id = String(describing: (contact.0 as AnyObject).value(forKey: "user_id")!)
            if(AppDelegate.senderId !=  id){
                
                cell.cnctname.text = String(describing: (contact.0 as AnyObject).value(forKey: "user_id") as! Int)
                latest = ModelManager.getInstance().getlatest("chat" , Int(AppDelegate.senderId)! , (contact.0 as AnyObject).value(forKey: "user_id")! as! Int)
                cell.timestmp.text = (contact.0 as AnyObject).value(forKey: "lastseen")! as? String
                var lastMsg: String!
                var obj: AnyObject!
                if latest.count > 0 {
                    if (latest.lastObject as AnyObject).count != 0 {
                        obj = latest.lastObject as AnyObject
                        lastMsg = obj.value(forKey: "message") as! String
                        
                    }
                }
                if obj != nil && ((contact.0 as AnyObject).value(forKey : "user_id") as? Int == obj?.value(forKey: "sender_id")! as? Int || (contact.0 as AnyObject).value(forKey : "user_id") as? Int == obj?.value(forKey: "receiver_id")! as? Int) {
//
                        cell.lstmsg.text = lastMsg
//
                }
                cell.msgcount.text = String(describing: contact.1)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row != 0) {
        let contact = contactNumber.object(at: indexPath.row - 1) as! (Any,Any)
        ChatController.reciever_id = ((contact.0) as AnyObject).value(forKey: "user_id") as! Int
        ChatController.type = "single"
        let a = ModelManager.getInstance().getack("chat", "\(ChatController.reciever_id!)", "status = \'false\'")
        if(a > 0 && AppDelegate.websocket.readyState == .OPEN) {
            do {
            let jsonData = try JSONSerialization.data(withJSONObject: ["type" : "readMsgAck" , "senderId" : ChatController.reciever_id!], options: .prettyPrinted)
            AppDelegate.websocket.send(NSData(data:jsonData))
                _ = ModelManager.getInstance().updateData("chat","status = \'true\'","status = \'false\' and sender_id = \(((contact.0) as AnyObject).value(forKey: "user_id") as! Int)")
            } catch {
            
            }
        }
        
        self.navigationController?.pushViewController(ChatController(), animated: true)
        }
    }
    
    //MARK: Custom methods
    func countmsg() {
        contactNumber = ModelManager.getInstance().getAllData("user")
        msgCount.removeAll()
        for i in contactNumber {
            let a = i as AnyObject
            let count = ModelManager.getInstance().getCount("chat", "sender_id = \(a.value(forKey: "user_id") as! Int) AND status = \'false\'", "status")
            msgCount.append(Int(count["COUNT(status)"] as! String)!)
            
        }
        contactNumber = zip(contactNumber, msgCount).sorted(by: { (a, b) -> Bool in
            return a.1 > b.1
        }) as! NSMutableArray
        tblvw.reloadData()
    }
    
    func edt(_ sender: AnyObject) {
        _ = ChatListController()
        self.navigationController?.pushViewController(ChatController(), animated: true)
        
    }
    
    func push() {
        self.navigationController?.pushViewController(NewGroupController(), animated: true)
    }
    
    func filterContentForSearchText() {
        
        self.tblvw.reloadData()
    }
    
    func abcd() {
        print("Jaadu")
    }
    
    func typing(_ notification : NSNotification) {
        if let senderId = notification.userInfo?["senderId"]! as? Int {
            let user = (contactNumber.filter{(($0 as! (Any,Any)).0 as AnyObject).value(forKey: "user_id")! as! Int == senderId} as! NSMutableArray).object(at: 0)
            let index = contactNumber.index(of: user)
            let indexPath = IndexPath(item: index + 1, section: 0)
            let cell = tblvw.cellForRow(at: indexPath) as! ChatListCell
            cell.lstmsg.text = "Typing..."
            tblvw.reloadRows(at: [indexPath], with: .none)
        } else {
            self.tblvw.reloadData()
        }
    }
    
}
