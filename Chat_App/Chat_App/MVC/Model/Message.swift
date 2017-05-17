//
//  Message.swift
//  Chat_App
//
//  Created by Developer88 on 5/15/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class Message: NSObject {
    var sender_id : Int
    var receiver_id : Int
    var message : String
    var time : String
    var status : Bool
    var ack : Int
    var image : UIImage
    var location : String
    
    //NTHI CHALTU
    
    class func getCallList(completion: @escaping (Message) -> Swift.Void) {
        let msg = ModelManager.getInstance().getList()
        for i in msg {
            let a = i as AnyObject
            let msg = Message.init(sender_id: Int(a.value(forKey: "sender_id")! as! String)! , receiver_id: Int(a.value(forKey: "receiver_id")! as! String)!, message: (a.value(forKey: "message") as? String)!, time: a.value(forKey: "time") as! String, status: (a.value(forKey: "status_user") as? Bool)!, ack: Int(a.value(forKey: "ack")! as! String)!, image: (UIImage(named: ""))!, location: a.value(forKey: "location") as! String)
            completion(msg)
        }
    }
    
    init(sender_id: Int, receiver_id: Int, message: String,time: String, status: Bool, ack: Int, image: UIImage,location: String) {
        self.sender_id = sender_id
        self.receiver_id = receiver_id
        self.message = message
        self.time = time
        self.status = status
        self.ack = ack
        self.image = image
        self.location = location
    }
    
}
