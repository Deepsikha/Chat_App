//
//  User.swift
//  Chat_App
//
//  Created by Devloper30 on 15/05/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class User: NSObject {
    
    let username: String!
    let user_id: Int!
    let status_user: String!
    let lastseen: String!
    let profile_pic: UIImage!
    let profile_thumb: UIImage!
    
    class func getAllUser(completion: @escaping (User) -> Swift.Void) {
        let user = ModelManager.getInstance().getAllData("user")
        for i in user {
            let a = i as AnyObject
            let piclink = URL.init(string: server_API.Base_url.appending(a.value(forKey: "profile_pic") as! String))
            let thumblink = URL.init(string: server_API.Base_url.appending(a.value(forKey: "profile_pic") as! String))
            URLSession.shared.dataTask(with: piclink!, completionHandler: { (data, response, error) in
                if error == nil {
                    let profile_pic = UIImage(data: data!)
                    URLSession.shared.dataTask(with: thumblink!, completionHandler: { (data, respone, error) in
                        if error == nil {
                            let profile_thumb = UIImage(data : data!)
                            let user = User.init(username: a.value(forKey: "username") as! String, user_id: (a.value(forKey: "user_id") as! Int), status_user: a.value(forKey: "status_user") as! String, lastseen: a.value(forKey: "lastseen") as! String, profile_pic: profile_pic!, profile_thumb: profile_thumb!)
                           
                            completion(user)
                        }
                    }).resume()
                }
            }).resume()
        }
    }
    
    init(username: String, user_id: Int,status_user: String, lastseen: String, profile_pic: UIImage, profile_thumb: UIImage) {
        self.username = username
        self.user_id = user_id
        self.status_user = status_user
        self.lastseen = lastseen
        self.profile_pic = profile_pic
        self.profile_thumb = profile_thumb
    }
}
