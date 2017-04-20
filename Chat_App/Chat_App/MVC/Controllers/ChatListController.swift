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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblvw.delegate = self
        tblvw.dataSource = self
        tblvw.register(UINib(nibName: "ChatArchCell", bundle: nil), forCellReuseIdentifier: "ChatArchCell")
        tblvw.register(UINib(nibName: "ChatListCell", bundle: nil), forCellReuseIdentifier: "ChatListCell")
    }

    //MARK: TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
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
        let cell = tblvw.dequeueReusableCell(withIdentifier: "ChatListCell", for: indexPath) as! ChatListCell
            cell.cnctname.text = "TEST"
            cell.lstmsg.text = "HELLO"
            cell.msgstatus.image = UIImage(named : "green")
            cell.prflpic.image = UIImage(named : "Gradient")
         return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(ChatController(), animated: true)
    }
    
    //MARK: Other methods
    
    func edit() {
        print("ABCD")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
