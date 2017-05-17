//
//  CallIntermediate.swift
//  Chat_App
//
//  Created by Developer88 on 5/12/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import SDWebImage
import SocketRocket

class CallIntermediate: UIViewController, SRWebSocketDelegate{

    @IBOutlet weak var imgvw: UIImageView!
    
    @IBOutlet weak var usrname: UILabel!
    @IBOutlet weak var clng: UILabel!
    @IBOutlet weak var rjct0: UIButton!
    @IBOutlet weak var rjct1: UIButton!
    @IBOutlet weak var acpt: UIButton!
    var timer : Timer!
    static var calling : Bool!
    var counter: Int = 25;
    var total: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timerStart()
        AppDelegate.websocket.delegate = self as SRWebSocketDelegate
        self.usrname.text = ChatController.recname
        self.navigationController?.isNavigationBarHidden = true
        let a = ModelManager.getInstance().exec("SELECT * from user where user_id = \(ChatController.reciever_id!)")
        let i = a as AnyObject
        let url = server_API.Base_url.appending(i.value(forKey: "profile_pic") as! String)
        self.imgvw.sd_setImage(with: URL(string: url), placeholderImage: nil, options: .progressiveDownload)
        
        if(CallIntermediate.calling) {
            self.acpt.isHidden =  true
            self.rjct1.isHidden = true
            self.clng.isHidden = false
            self.rjct0.isHidden = false
        } else {
            self.acpt.isHidden =  false
            self.rjct1.isHidden = false
            self.clng.isHidden = true

            self.rjct0.isHidden = true
        }
        
    }

    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        let dic = convertToDictionary(text: message as! String)
        print(dic!)
        do {
            var _:[String:Any]!
            var _: Data!
            switch dic!["type"] as! String {
            case "acceptVCall":
                self.navigationController?.pushViewController(VChatController(), animated: false)
                break
            case "declineVCall":
                            _ = ModelManager.getInstance().addData("calls", "type,sender_id,receiver_id,time,duration", "\'\(ChatController.ctype!)\',\'\(ChatController.reciever_id!)\',\'\(AppDelegate.senderId)\',\'\(Date())\','0'")
                self.navigationController?.popViewController(animated: false)
                break
            default:
                break
            }
        }
    }
    
    @IBAction func accpt(_ sender: Any) {
        do {
            let json = try JSONSerialization.data(withJSONObject: ["type":"acceptVideoCall","receiver_id": ChatController.reciever_id], options: .prettyPrinted)
        AppDelegate.websocket.send(json)
        self.navigationController?.pushViewController(VChatController(), animated: false)
        } catch {
            
        }
    }
    
    @IBAction func rjct(_ sender: Any) {
        do {
            let json = try JSONSerialization.data(withJSONObject: ["type" : "declineVideoCall", "receiver_id" : ChatController.reciever_id!], options: .prettyPrinted)
        AppDelegate.websocket.send(json)
        } catch {
        }
        self.navigationController?.popViewController(animated: false)
    }

    func timerStart() {
        
        if(timer == nil) {
            timer = Timer.init(timeInterval: 1, target: self, selector: #selector(Verification.timerFunction(_:)), userInfo: nil, repeats: true);
            let runloop: RunLoop = RunLoop.current;
            runloop.add(timer, forMode: RunLoopMode.defaultRunLoopMode);
        }
    }
    
    func timerFunction(_ atimer:Timer) {
        counter -= 1;
        if(counter == total) {
            timer.invalidate();
            _ = ModelManager.getInstance().addData("calls", "type,sender_id,receiver_id,time,duration", "\'\(ChatController.ctype!)\',\'\(AppDelegate.senderId)\',\'\(ChatController.reciever_id!)\',\'\(Date())\','0'")
            do {
                let json = try JSONSerialization.data(withJSONObject: ["type" : "declineVideoCall", "receiver_id" : ChatController.reciever_id!], options: .prettyPrinted)
                AppDelegate.websocket.send(json)
            } catch {
            }
            self.navigationController?.popViewController(animated: false)
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
