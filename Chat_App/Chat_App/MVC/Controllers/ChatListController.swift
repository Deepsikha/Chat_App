//
//  ChatListController.swift
//  Chat_App
//
//  Created by Developer88 on 4/20/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import SDWebImage
class ChatListController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SDWebImageManagerDelegate {
    
    @IBOutlet weak var tblvw: UITableView!
    
    @IBOutlet var search: UISearchBar!
    @IBOutlet var lblArchiveNo: UILabel!
    @IBOutlet var vwHeader: UIView!
    static var sender = 0
    var contactNumber : NSMutableArray!
    var last = [String]()
    var msgCount: [Int]! = []
    var latest = NSMutableArray()
    var filtercontactNumber = NSMutableArray()
    static var searchText : String!
    var isSearch:Bool = false
    var imageCache : SDImageCache!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countmsg()
        
        search.delegate = self
        tblvw.delegate = self
        tblvw.dataSource = self
        
        self.navigationController?.isToolbarHidden = true
        tblvw.register(UINib(nibName: "ChatArchCell", bundle: nil), forCellReuseIdentifier: "ChatArchCell")
        tblvw.register(UINib(nibName: "ChatListCell", bundle: nil), forCellReuseIdentifier: "ChatListCell")
        self.tblvw.tableHeaderView = self.vwHeader
        self.search.placeholder = "Search"
        NotificationCenter.default.addObserver(self, selector: #selector(countmsg), name: NSNotification.Name(rawValue : "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(typing(_:)), name: Notification.Name(rawValue : "type"), object: nil)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        countmsg()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        countmsg()
    }
    //MARK: Table Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.isSearch) {
            return filtercontactNumber.count
        } else {
            return contactNumber.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var contact:(Any,Any)!
        if self.isSearch{
            contact = filtercontactNumber.object(at: indexPath.row) as! (Any,Any)
        } else {
            contact = contactNumber.object(at: indexPath.row) as! (Any,Any)
        }
        
        let cell = tblvw.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath) as! ChatListCell

        let url = server_API.Base_url.appending(String(describing: (contact.0 as AnyObject).value(forKey: "profile_pic") as! String))
        
        cell.prflpic.sd_setImage(with: URL(string: url), placeholderImage: nil, options: SDWebImageOptions.scaleDownLargeImages, completed: { (image, error, memory, imageUrl) in
        })
        
        let id = String(describing: (contact.0 as AnyObject).value(forKey: "user_id")!)
        if(AppDelegate.senderId !=  id){
            
            cell.cnctname.text = String(describing: (contact?.0 as AnyObject).value(forKey: "username") as! String)
            latest = ModelManager.getInstance().getlatest("chat" , Int(AppDelegate.senderId)! , (contact.0 as AnyObject).value(forKey: "user_id")! as! Int)
            
            
            var lastMsg: String!
            var obj: AnyObject!
            if latest.count > 0 {
                if (latest.lastObject as AnyObject).count != 0 {
                    obj = latest.lastObject as AnyObject
                    lastMsg = obj.value(forKey: "message") as! String
                    cell.lstmsg.text = lastMsg
                    
                }
            }
            if obj != nil && ((contact.0 as AnyObject).value(forKey : "user_id") as? Int == obj?.value(forKey: "sender_id")! as? Int || (contact.0 as AnyObject).value(forKey : "user_id") as? Int == obj?.value(forKey: "receiver_id")! as? Int) {
                    var a = (obj.value(forKey: "time") as? String)?.components(separatedBy: " ")
//                    cell.timestmp.text = a?[4]
//                    cell.lstmsg.text = lastMsg
            }
            cell.msgcount.text = String(describing: contact.1)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var contact:(Any,Any)!
        if self.isSearch{
            contact = filtercontactNumber.object(at: indexPath.row) as! (Any,Any)
        } else {
            contact = contactNumber.object(at: indexPath.row) as! (Any,Any)
        }
         let cell:ChatListCell? = tblvw.cellForRow(at: indexPath) as? ChatListCell
        ChatController.recname = String(describing: (contact.0 as AnyObject).value(forKey: "username") as! String)
        ContactInfoController.status = String(describing: (contact.0 as AnyObject).value(forKey: "status_user") as! String)
        ChatController.reciever_id = (contact.0 as AnyObject).value(forKey: "user_id") as! Int
        ChatController.type = "single"
        ChatController.img = cell?.prflpic.image
        ContactInfoController.img = cell?.prflpic.image
        let a = ModelManager.getInstance().getack("chat", "\(ChatController.reciever_id!)", "status = \'false\'")
        if(a > 0 && AppDelegate.websocket.readyState == .OPEN) {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: ["type" : "readMsgAck" , "senderId" : ChatController.reciever_id!], options: .prettyPrinted)
                AppDelegate.websocket.send(NSData(data:jsonData))
                
            } catch {
                
            }
        }
        self.navigationController?.pushViewController(ChatController(), animated: true)
    }
    
    //MARK:- Search Delegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true
        
        var r = self.view.frame
        r.origin.y = -44
        r.size.height += 44
        self.view.frame = r
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if isSearch == true{
            isSearch = false
            tblvw.reloadData()
        }
        searchBar.text = ""
        self.search.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        var r = self.view.frame
        r.origin.y = 0
        r.size.height -= 44
        self.view.frame = r
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.isEmpty)!{
            isSearch = false
            tblvw.reloadData()
        } else {
            isSearch = true
            filt()
        }
    }
    
    func filt()
    {
        filtercontactNumber.removeAllObjects()
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", self.search.text!)
        let array = (contactNumber.value(forKey: "username") as! NSArray).filtered(using: searchPredicate)
        filtercontactNumber = array as! NSMutableArray
        
    }
    
    //MARK:- Outlet Methods
    @IBAction func handleArchieve(_ sender: Any) {
        
    }
    
    @IBAction func handleBroadcast(_ sender: Any) {
    }
    
    
    @IBAction func handleNewGroup(_ sender: Any) {
        self.navigationController?.pushViewController(NewGroupController()
            , animated: true)
    }
    
    //MARK: Custom Methods
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
    
    func typing(_ notification : NSNotification) {
        if let senderId = notification.userInfo?["Id"]! as? Int {
            let user = (contactNumber.filter{(($0 as! (Any,Any)).0 as AnyObject).value(forKey: "user_id")! as! Int == senderId} as! NSMutableArray).object(at: 0)
            let index = contactNumber.index(of: user)
            let indexPath = IndexPath(item: index , section: 0)
            let cell = tblvw.cellForRow(at: indexPath) as! ChatListCell
            cell.lstmsg.text = "Typing..."
        } else {
            
            self.tblvw.reloadData()
        }
    }

}
