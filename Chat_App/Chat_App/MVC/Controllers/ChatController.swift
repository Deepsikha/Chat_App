//
//  ChatController.swift
//  Chat_App
//
//  Created by Developer88 on 4/17/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import QuartzCore
import SocketRocket
import Crashlytics

class ChatController: UIViewController, UITableViewDelegate, UITableViewDataSource, SRWebSocketDelegate, UITextViewDelegate {
    
    @IBOutlet weak var chatboxTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendmsg: UIButton!
    @IBOutlet weak var scrlbtn: UIButton!
    @IBOutlet weak var sendaudio: UIButton!
    @IBOutlet weak var addphto: UIButton!
    @IBOutlet weak var addmedia: UIButton!
    @IBOutlet var navvw: UIView!
    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var tblvw: UITableView!
    @IBOutlet weak var chatbox: UITextView!
    @IBOutlet weak var navprof: UIImageView!
    @IBOutlet weak var cnctnm: UILabel!
    @IBOutlet weak var lstseen: UILabel!
    
    static var type : String!
    var i = 4
    var frame : CGRect!
    static var reciever_id : Int!
    var frame1 : CGRect!
    var messages : NSMutableArray!
    var chatboxConstant : CGFloat!
    private var lastContentOffset: CGFloat = 0
    var maxStringLength = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(ChatController.reciever_id!)"
        if (self.title?.lengthOfBytes(using: .ascii))! > maxStringLength {
            let index = self.title?.index((self.title?.startIndex)!, offsetBy: 5)
            self.title = self.title?.substring(to: index!).appending("...")
        }
        else {
            navigationItem.backBarButtonItem?.title = self.title
        }
        if(ChatController.type == "single") {
            self.cnctnm.text = String(describing : ChatController.reciever_id!)
            let btn1 = UIButton(type: .custom)
            let origImage = UIImage(named: "Calls");
            let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            btn1.setImage(tintedImage, for: .normal)
            btn1.tintColor = UIColor.init(red: 49/255, green: 192/255, blue: 239/255, alpha: 1)
            btn1.frame = CGRect(x: UIScreen.main.bounds.origin.x - 50, y: 20, width: 30, height: 30)
            btn1.addTarget(self, action: #selector(edit),for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: btn1)
            
            let btn2 = UIButton(type: .custom)
            let origImage1 = UIImage(named: "videocall")
            let tintedImage1 = origImage1?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            btn2.setImage(tintedImage1, for: .normal)
            btn2.tintColor = UIColor.init(red: 49/255, green: 192/255, blue: 239/255, alpha: 1)
            btn2.frame = CGRect(x: UIScreen.main.bounds.origin.x - 35, y: 20, width: 30, height: 30)
            btn2.addTarget(self, action: #selector(edit), for: .touchUpInside)
            let item2 = UIBarButtonItem(customView: btn2)
            self.navigationItem.setRightBarButtonItems([item1,item2], animated: true)
        } else if(ChatController.type == "Group") {
            self.lstseen.text = "A,B,C,D"
        }
        chatbox.delegate = self
        AppDelegate.websocket.delegate = self as SRWebSocketDelegate
        tblvw.delegate = self
        tblvw.dataSource = self
        self.tblvw.estimatedRowHeight = 100
        self.tblvw.rowHeight = UITableViewAutomaticDimension
        tblvw.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        tblvw.register(UINib(nibName: "ReceiverCell", bundle: nil), forCellReuseIdentifier: "ReceiverCell")
        chatbox.layer.cornerRadius = chatbox.frame.height / 2
        navvw.frame = CGRect(x : 70, y: 0, width : (self.navigationController?.navigationBar.frame.width)! - 150,height: 44)
        self.navigationItem.titleView = navvw
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler))
        tap.cancelsTouchesInView = false
        self.tblvw.addGestureRecognizer(tap)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.openprofl))
        tap1.cancelsTouchesInView = false
        self.navvw.addGestureRecognizer(tap1)
        getMsg()
        
    }
    
    func getMsg() {
        self.messages = ModelManager.getInstance().getData("chat", "\(AppDelegate.senderId)", "\(ChatController.reciever_id!)", "message")
        
        tblvw.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
    let jsonData = try JSONSerialization.data(withJSONObject: ["type" : "userstatus" , "userId" : ChatController.reciever_id!], options: .prettyPrinted)
        AppDelegate.websocket.send(NSData(data:jsonData))
    } catch {
    
    }
    Answers.logContentView(withName: "Content event",contentType: "Testing", contentId: "1",customAttributes: ["Custom String" : "Mike","Custom Number" : 35])
        
        //purchase
        Answers.logPurchase(withPrice: 1000, currency: "rupee", success: true, itemName: "tutorial", itemType: "study", itemId: "12", customAttributes: ["Custom String" : "Mike","Custom Number" : 35])
        
        //AddToCart
        Answers.logAddToCart(withPrice: 1000, currency: "rupee", itemName: "tutorial", itemType: "study", itemId: "12", customAttributes: ["Custom String" : "Mike","Custom Number" : 35])
        
        //CheckOut
        Answers.logStartCheckout(withPrice: 1000, currency: "rupee", itemCount: 3, customAttributes: ["Custom String" : "Mike","Custom Number" : 35])
    }
    
    override func viewDidLayoutSubviews() {
        frame1 = vw.frame
        chatboxConstant = chatboxTrailingConstraint.constant
        self.sendmsg.isHidden = true
        self.scrlbtn.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if messages.count > 0 {
            let lastRow: Int = self.tblvw.numberOfRows(inSection: 0) - 1
            let indexPath = IndexPath(row: lastRow, section: 0);
            self.tblvw.scrollToRow(at: indexPath, at: .top, animated: false)
        }
        
        self.chatbox.backgroundColor = UIColor.white
        self.navprof.image = UIImage(named: "Gradient")
        self.navprof.layer.cornerRadius = self.navprof.frame.width / 2
        NotificationCenter.default.addObserver(self, selector: #selector(ChatController.showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatController.hideKeyBoard(_ :)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    //MARK:- Table Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let ob = (self.messages.object(at: indexPath.row) as AnyObject)
        
        if ob.value(forKey: "sender_id") as! String == AppDelegate.senderId {
            let cell = tblvw.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
            cell.messageBackground.layer.borderWidth = 2
            cell.message.text = ob.value(forKey: "message") as? String
            switch Int.init((ob.value(forKey: "ack") as! String))! {
            case 0:
                cell.messageBackground.layer.borderColor = UIColor.black.cgColor
                break
            case 1:
                cell.messageBackground.layer.borderColor = UIColor.red.cgColor
                break
            case 2:
                cell.messageBackground.layer.borderColor = UIColor.yellow.cgColor
                break
            case 3:
                cell.messageBackground.layer.borderColor = UIColor.clear.cgColor
                break
            default:
                print("ABCD")
            }
            cell.stamp.text = ob.value(forKey: "time") as? String
            return cell
        } else {
            let cell1 = tblvw.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
            cell1.message.text = ob.value(forKey: "message") as? String
            return cell1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrlbtn.isHidden = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset < scrollView.contentOffset.y) {
           self.scrlbtn.isHidden = false
        } else if (self.lastContentOffset > scrollView.contentOffset.y){
            self.scrlbtn.isHidden = true
        }
        self.lastContentOffset = scrollView.contentOffset.y
    }
   
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        self.lstseen.text = "Offline"
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        let dic = convertToDictionary(text: message as! String)
        print(dic!)
        do {
            var _:[String:Any]!
            var _: Data!
            switch dic!["type"] as! String {
            case "error":
                
                break
            case "authErr":
                
                break
            case "connected":
                let a = ModelManager.getInstance().senddataserver("chat")
                for i in a {
                    let ob = i as AnyObject
                    var dic:[String:Any]!
                    dic = ["senderId": ob.value(forKey: "sender_id")! as! Int,"message": ob.value(forKey: "message")! as! String,"recieverId": ob.value(forKey: "receiver_id")! as! Int,"type":"message"]
                    let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
                    if(AppDelegate.websocket.readyState != SRReadyState.CLOSED) {
                        AppDelegate.websocket.send(NSData(data:jsonData))
                        
                        _ = ModelManager.getInstance().updateData("chat", "ack = 1", "ack = 0 and rowid = \(String(describing: ob.value(forKey: "id")!))")
                    }
                }
                
                break
            case "msgAck":
                switch dic!["msgAck"] as! Int {
                case 1:
                   _ = ModelManager.getInstance().updateData("chat", "ack = 2","ack = 1 and receiver_id = \(String(describing: dic?["senderId"]! as! Int))")
                    
                    break
                case 3:
                   _ = ModelManager.getInstance().updateData("chat", "ack = 3","ack = 2 or ack = 1 and receiver_id = \(String(describing: dic?["senderId"]! as! Int))")
                    break
                default:
                    print("ABCD")
                    
                }
                getMsg()
                break
            case "message":
                for i in dic!["data"] as! NSArray {
                    let a = i as AnyObject
                    _ = ModelManager.getInstance().addData("chat", "sender_id,receiver_id,message,time,status", "\(String(describing: a.value(forKey: "sender_id") as! Int)),\(AppDelegate.senderId),\'\(String(describing: a.value(forKey: "message")!))\',\'\(String(describing: a.value(forKey: "time")!))\',\'true\'")
                    
                    ChatListController.sender = (a.value(forKey: "sender_id") as! Int)
                    getMsg()
                    let lastRow: Int = self.tblvw.numberOfRows(inSection: 0) - 1
                    let indexPath = IndexPath(row: lastRow, section: 0);
                    self.tblvw.scrollToRow(at: indexPath, at: .top, animated: false)
                    if (a.value(forKey: "sender_id") as! Int) == ChatController.reciever_id {
                        do{
                    let jsonData = try JSONSerialization.data(withJSONObject: ["type" : "readMsgAck" , "senderId" : ChatController.reciever_id!], options: .prettyPrinted)
                        AppDelegate.websocket.send(NSData(data:jsonData))
                        } catch {
                        
                        }
                     }
                }
                
                break
            case "userStatus":
                switch dic?["online"]! as! Int {
                case 0:
                    self.lstseen.text = "Offline"
                    break
                case 1:
                    self.lstseen.text = "Online"
                    break
                case 2:
                    self.lstseen.text = "Typing..."
                case 3:
                    self.lstseen.text = "Online"
                    break
                default:
                    print("asds")
                }
                break
            default: break
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    //MARK:- Outlet Method
    
    @IBAction func scrollbtm(_ sender: Any) {
        let lastRow: Int = self.tblvw.numberOfRows(inSection: 0) - 1
        let indexPath = IndexPath(row: lastRow, section: 0);
        self.tblvw.scrollToRow(at: indexPath, at: .top, animated: false)
        self.scrlbtn.isHidden = true
    }
    
    
    @IBAction func didpressaccessory(_ sender: Any) {
        let sheet = UIAlertController(title: "Media messages", message: nil, preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Send Photo/Video", style: .default) { (action) in
            /**
             *  Create fake photo
             */
            self.addphoto()
            
        }
        
        let locationAction = UIAlertAction(title: "Send location", style: .default) { (action) in
            /**
             *  Add fake location
             */
            //            let locationItem = self.buildLocationItem()
            //
            //            self.addMedia(locationItem)
        }
        
        let audioAction = UIAlertAction(title: "Send audio", style: .default) { (action) in
            /**
             *  Add fake audio
             */
            //            let audioItem = self.buildAudioItem()
            //
            //            self.addMedia(audioItem)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(photoAction)
        sheet.addAction(locationAction)
        sheet.addAction(audioAction)
        sheet.addAction(cancelAction)
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    @IBAction func sendmsg(_ sender: Any) {
        do {
        
            var dic:[String:Any]!
            dic = ["senderId":Int(AppDelegate.senderId)!,"message": chatbox.text! ,"recieverId":ChatController.reciever_id,"type":"message"]
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            if(AppDelegate.websocket.readyState == SRReadyState.OPEN && self.chatbox.text != "") {
                AppDelegate.websocket.send(NSData(data: jsonData))
                _ = ModelManager.getInstance().addData("chat", "sender_id,receiver_id,message,time,ack", "\(String(describing: dic!["senderId"]!)),\(String(describing: dic!["recieverId"]!)),\'\(String(describing: dic!["message"]!))\',\'\(Date().addingTimeInterval(5.5))\',1")
            } else if(self.chatbox.text != "") {
            messages.add(["sender_id":AppDelegate.senderId,"receiver_id":ChatController.reciever_id,"message":chatbox.text!,"time":Date(),"status":"0"])
                _ = ModelManager.getInstance().addData("chat", "sender_id,receiver_id,message,time,ack", "\(String(describing: dic!["senderId"]!)),\(String(describing: dic!["recieverId"]!)),\'\(String(describing: dic!["message"]!))\',\'\(Date().addingTimeInterval(5.5))\',0")
            }
        } catch {
            print(error.localizedDescription)
        }
        self.addphto.isHidden = true
        self.sendaudio.isHidden = true
        self.sendmsg.isHidden = false
        getMsg()
        let lastRow: Int = self.tblvw.numberOfRows(inSection: 0) - 1
        let indexPath = IndexPath(row: lastRow, section: 0);
        self.tblvw.scrollToRow(at: indexPath, at: .top, animated: false)
        self.chatbox.text = ""
        
    }
    
    
    //MARK:- Custom Method
    
    func menu() {
        
    
    }
    
    func addphoto() {
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func tapHandler() {
        self.chatbox.text = ""
        UIView.animate(withDuration: 0.8) {
            self.chatbox.resignFirstResponder()
            self.addphto.isHidden = false
            self.sendaudio.isHidden = false
            self.sendmsg.isHidden = true
            self.chatboxTrailingConstraint.constant = self.chatboxConstant
        }
    }
    
    func openprofl() {
        self.navigationController?.pushViewController(ContactInfoController(), animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
            self.addphto.isHidden = true
            self.sendaudio.isHidden = true
            self.sendmsg.isHidden = false
            let constant = UIScreen.main.bounds.width * 48 / 375;
            self.chatboxTrailingConstraint.constant = -constant
            self.vw.layoutIfNeeded()
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: ["type" : "typing" , "userId" : ChatController.reciever_id!, "typing" : true], options: .prettyPrinted)
            AppDelegate.websocket.send(NSData(data:jsonData))
        } catch {
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: ["type" : "typing" , "userId" : ChatController.reciever_id!, "typing" : false], options: .prettyPrinted)
            AppDelegate.websocket.send(NSData(data:jsonData))
        } catch {
            
        }
    }
    
    func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.tblvw.contentInset.bottom = height
            self.tblvw.scrollIndicatorInsets.bottom = height
            print(height)
            self.vw.frame = CGRect(x: frame1.origin.x, y: self.view.frame.height - height - frame1.height, width: frame1.width, height: frame1.height)
        if messages.count > 0 {
                            if i > 0 {
                    let lastRow: Int = self.tblvw.numberOfRows(inSection: 0) - 1
                    let indexPath = IndexPath(row: lastRow, section: 0);
                    self.tblvw.scrollToRow(at: indexPath, at: .top, animated: false)
                }
            }
        }

    }
    
    func hideKeyBoard(_ notification : Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.tblvw.contentInset.bottom = self.tblvw.contentInset.bottom - height
            self.vw.frame = frame1
        if messages.count > 0 {
        
            self.tblvw.scrollIndicatorInsets.bottom = self.tblvw.scrollIndicatorInsets.bottom - height
            let lastRow: Int = self.tblvw.numberOfRows(inSection: 0) - 1
            let indexPath = IndexPath(row: lastRow, section: 0);
            self.tblvw.scrollToRow(at: indexPath, at: .top, animated: false)
        }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        chatbox.sizeThatFits
    }
    
    func edit() {
        print("sdfsdfasdfsdf")
    }
    
}
