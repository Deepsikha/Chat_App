//
//  HomeController.swift
//  Chat_App
//
//  Created by Developer88 on 4/17/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import SocketRocket

class HomeController: UITabBarController, UITabBarControllerDelegate , SRWebSocketDelegate {
    
    
    var tab1 = StatusController()
    var tab2 = CallsController()
    var tab3 = CameraController()
    var tab4 = ChatListController()
    var tab5 = SettingsController()
    var temp = UIViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.title = "Chat"

        let editbtn = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(edit(_:)))
        editbtn.accessibilityHint = tab4.nibName
        editbtn.tag = 0
        
        self.navigationItem.leftBarButtonItem = editbtn
        let button1 = UIBarButtonItem(image: UIImage(named: "Edit"), style: .plain, target: self, action: #selector(edit(_:)))
        
        button1.accessibilityHint = tab4.nibName
        button1.tag = 1
        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItem = button1     
        let tabOne = StatusController()
        tabOne.tabBarItem = UITabBarItem(title: "Status", image: UIImage(named: ""), tag: 1)
        
        let tabTwo = CallsController()
        tabTwo.tabBarItem = UITabBarItem(title: "Calls", image: UIImage(named: "Calls"), tag: 2)
        
        let tabThree = CameraController()
        tabThree.tabBarItem = UITabBarItem(title: "Camera", image: UIImage(named: "Camera"), tag: 3)
        

        tab1.tabBarItem = UITabBarItem(title: "Status", image: UIImage(named: ""), tag: 1)
        
        tab2.tabBarItem = UITabBarItem(title: "Calls", image: UIImage(named: "Calls"), tag: 2)
        
        tab3.tabBarItem = UITabBarItem(title: "Camera", image: UIImage(named: "Camera"), tag: 3)
        
        
        tab4.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(named: "chaticon"), tag: 4)
        
        tab5.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "Settings"), tag: 5)
        self.viewControllers = [tab1,tab2,tab3,tab4,tab5]
        self.selectedViewController = tab4

        connect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false       
        AppDelegate.websocket.delegate = self

    }
    
    //MARK: Tabbar Delegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch viewController {
        case is ChatListController:
            self.title = "Chat"
            let editbtn = UIBarButtonItem(title: "Edit", style: .plain, target: self , action: #selector(edit(_:)))
            editbtn.accessibilityHint = viewController.nibName
            editbtn.tag = 0
            self.navigationItem.leftBarButtonItem = editbtn
            let button1 = UIBarButtonItem(image: UIImage(named: "Edit"), style: .plain, target: self, action: #selector(edit))
            button1.accessibilityHint = viewController.nibName
            button1.tag = 1
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItem = button1
            
            break
        case is StatusController:
            temp.accessibilityHint = "Status"
            self.title = "Status"
            self.navigationItem.titleView = nil

            let button1 = UIBarButtonItem(image: UIImage(named: "AddStatus"), style: .plain, target: self, action: #selector(edit(_:)))
            button1.accessibilityHint = viewController.nibName
            button1.tag = 0
            let button2 = UIBarButtonItem(title: "Privacy", style: UIBarButtonItemStyle.plain, target: self, action: #selector(edit(_:)))
            button2.accessibilityHint = viewController.nibName
            button2.tag = 1

            
            self.navigationItem.rightBarButtonItem = button1
            self.navigationItem.leftBarButtonItem = button2
            break
        case is CallsController:
            temp.accessibilityHint = "Calls"
            self.title = "Calls"
            let button1 = UIBarButtonItem(image: UIImage(named: "Calls"), style: .plain, target: self, action: #selector(edit(_:)))
            button1.accessibilityHint = viewController.nibName
            button1.tag = 0
            self.navigationItem.rightBarButtonItem = button1
            let segment: UISegmentedControl = UISegmentedControl(items: ["All", "Missed"])
        
            segment.sizeToFit()
            segment.selectedSegmentIndex = 0
            self.navigationItem.titleView = segment
            self.navigationItem.leftBarButtonItem = nil
            break
        case is CameraController:
            self.title = "Camera"
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.titleView = nil
            self.navigationItem.leftBarButtonItem = nil
            break
        case is SettingsController:
            self.title = "Settings"
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.leftBarButtonItem = nil
            break
        default:
            print("")
        }
    }
    

    //MARK: Socket Methods
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print(reason)
    }
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        print("Connected")
        if(AppDelegate.websocket.readyState == SRReadyState.OPEN) {
            sendInitMsg()
        }
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
                  _ = ModelManager.getInstance().updateData("chat", "ack = 2","ack = 1 and receiver_id = \(String(describing: dic?["senderId"]!) as! Int)")
                    break
                case 3:
                  _ = ModelManager.getInstance().updateData("chat", "ack = 3","ack = 2 or ack = 1 and receiver_id = \(String(describing: dic?["senderId"]!) as! Int)")

                    break
                default:
                    print("ABCD")
                }
            case "message":
                for i in dic!["data"] as! NSArray {
                    let a = i as AnyObject
                    _ = ModelManager.getInstance().addData("chat", "sender_id,receiver_id,message,time,status", "\(String(describing: a.value(forKey: "sender_id") as! Int)),\(AppDelegate.senderId),\'\(String(describing: a.value(forKey: "message")!))\',\'\(String(describing: a.value(forKey: "time")!))\',\'false\'")
                    ChatListController.sender = (a.value(forKey: "sender_id") as! Int)
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                break
            case "userStatus":
                if(dic?["online"] as! Int == 2) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue : "type"), object: nil, userInfo: dic)
                } else if(dic?["online"] as! Int == 3) {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue : "type"), object: nil, userInfo: nil)
                }
                break
            default: break
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    //MARK: Custom Methods
    func connect() {
      AppDelegate.websocket = SRWebSocket(url: URL(string: "https://moqmvipayp.localtunnel.me"))
        AppDelegate.websocket.open()
    }
    
    func sendInitMsg(){
        do {
            var dic:[String:Any]!
            dic = ["senderId": AppDelegate.senderId,"type":"initConnection"]  
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            AppDelegate.websocket.send(NSData(data: jsonData))
        } catch {
            print(error.localizedDescription)
        }
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
    
    func edit(_ sender: AnyObject) {
        switch sender.accessibilityHint!! {
        case "ChatListController":
            self.selectedViewController = tab4
            if sender.tag == 0 {
                print("edit")
                tab4.tblvw.isEditing = true
            } else {
                let vc = NewChatVC()
                vc.caller = "ChatListController"
                self.navigationController?.pushViewController(vc, animated: true)
                print("right")
            }
            break
        case "CallsController":
            self.selectedViewController = tab2
            let vc = NewChatVC()
            vc.caller = "CallsController"
            self.navigationController?.pushViewController(vc, animated: true)
             //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            break
            
        case "StatusController":
            self.selectedViewController = tab1
            print("The letter A")
            break
        default:
            break
        }
    }
    
}
