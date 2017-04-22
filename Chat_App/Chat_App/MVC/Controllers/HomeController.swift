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
    
    let tabFour = ChatListController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        connect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.title = "Chat"
        let button1 = UIBarButtonItem(image: UIImage(named: "Edit"), style: .plain, target: self, action: #selector(ChatListController.edit))
        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItem = button1
        let editbtn = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(ChatListController.edit))
        self.navigationItem.leftBarButtonItem = editbtn
        
        let tabOne = StatusController()
        tabOne.tabBarItem = UITabBarItem(title: "Status", image: UIImage(named: ""), tag: 1)
        
        let tabTwo = CallsController()
        tabTwo.tabBarItem = UITabBarItem(title: "Calls", image: UIImage(named: "Calls"), tag: 2)
        
        let tabThree = CameraController()
        tabThree.tabBarItem = UITabBarItem(title: "Camera", image: UIImage(named: "Camera"), tag: 3)
        
        
        tabFour.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(named: "chaticon"), tag: 4)
        
        let tabFive = SettingsController()
        tabFive.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "Settings"), tag: 5)
        self.viewControllers = [tabOne,tabTwo,tabThree,tabFour,tabFive]
        
        
        
        self.selectedViewController = tabFour
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: Tabbar Methods
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch viewController {
        case is ChatListController:
            self.title = "Chat"
            let editbtn = UIBarButtonItem(title: "Edit", style: .plain, target: tabFour , action: #selector(tabFour.edit))
            self.navigationItem.leftBarButtonItem = editbtn
            let button1 = UIBarButtonItem(image: UIImage(named: "Edit"), style: .plain, target: viewController, action: #selector(ChatListController.edit))
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItem = button1
            break
        case is StatusController:
            self.title = "Status"
            self.navigationItem.titleView = nil
            let button1 = UIBarButtonItem(image: UIImage(named: "AddStatus"), style: .plain, target: self, action: #selector(ChatListController.edit))
            self.navigationItem.rightBarButtonItem = button1
            self.navigationItem.leftBarButtonItem = nil
            break
        case is CallsController:
            self.title = "Calls"
            let button1 = UIBarButtonItem(image: UIImage(named: "Calls"), style: .plain, target: self, action: #selector(ChatListController.edit))
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
    
    func connect() {
        AppDelegate.websocket = SRWebSocket(url: URL(string: "https://wtwvyitmgx.localtunnel.me"))
        AppDelegate.websocket.delegate = self
        AppDelegate.websocket.open()
    }
    
    func webSocket(_ webSocket: SRWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        print(reason)
    }
    
    func webSocketDidOpen(_ webSocket: SRWebSocket!) {
        print("Connected")
        if(AppDelegate.websocket.readyState == SRReadyState.OPEN) {
            sendInitMsg()
        }
    }
    
    func sendInitMsg(){
        do {
            var dic:[String:Any]!
            dic = ["senderId": "9610555504","type":"initConnection"]
            
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            AppDelegate.websocket.send(NSData(data: jsonData))
        } catch {
            print(error.localizedDescription)
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
                
                break
            case "message":
                for i in dic!["data"] as! NSArray {
                    let a = i as AnyObject
                    _ = ModelManager.getInstance().addData("chat", "sender_id,receiver_id,message,time,status", "\(String(describing: a.value(forKey: "sender_id") as! Int)),\(AppDelegate.senderId),\'\(String(describing: a.value(forKey: "message")!))\',\'\(String(describing: a.value(forKey: "time")!))\',\'false\'")
                    ChatListController.sender = (a.value(forKey: "sender_id") as! Int)
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                break
            case "readMsgAck":
                
                break
            default: break
            }
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
    
}
