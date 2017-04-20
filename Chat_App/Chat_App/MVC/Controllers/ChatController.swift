//
//  ChatController.swift
//  Chat_App
//
//  Created by Developer88 on 4/17/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import QuartzCore

class ChatController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var i = 4
    @IBOutlet var navvw: UIView!
    @IBOutlet weak var vw: UIView!
    @IBOutlet weak var tblvw: UITableView!
    @IBOutlet weak var chatbox: UITextField!
    @IBOutlet weak var navprof: UIImageView!
    @IBOutlet weak var cnctnm: UILabel!
    @IBOutlet weak var lstseen: UILabel!
    
    var frame1 : CGRect!

    override func viewDidLoad() {
        super.viewDidLoad()
        tblvw.delegate = self
        tblvw.dataSource = self
        self.tblvw.estimatedRowHeight = 100
        self.tblvw.rowHeight = UITableViewAutomaticDimension
        tblvw.register(UINib(nibName: "SenderCell", bundle: nil), forCellReuseIdentifier: "SenderCell")
        tblvw.register(UINib(nibName: "ReceiverCell", bundle: nil), forCellReuseIdentifier: "ReceiverCell")
        chatbox.layer.cornerRadius = 20
        
        self.navigationController?.isNavigationBarHidden = false
        let btn1 = UIButton(type: .custom)
        let origImage = UIImage(named: "Calls");
        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        btn1.setImage(tintedImage, for: .normal)
        btn1.tintColor = UIColor.init(red: 49/255, green: 192/255, blue: 239/255, alpha: 1)
        btn1.frame = CGRect(x: UIScreen.main.bounds.origin.x - 50, y: 20, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(hideKeyBoard(notification:)), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        let btn2 = UIButton(type: .custom)
        let origImage1 = UIImage(named: "videocall")
        let tintedImage1 = origImage1?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        btn2.setImage(tintedImage1, for: .normal)
        btn2.tintColor = UIColor.init(red: 49/255, green: 192/255, blue: 239/255, alpha: 1)
        btn2.frame = CGRect(x: UIScreen.main.bounds.origin.x - 35, y: 20, width: 30, height: 30)
        btn2.addTarget(self, action: #selector(hideKeyBoard(notification:)), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: btn2)
        self.navigationItem.setRightBarButtonItems([item1,item2], animated: true)
        navvw.frame = CGRect(x : 70, y: 0, width : (self.navigationController?.navigationBar.frame.width)! - 150,height: 44)
        self.navigationItem.titleView = navvw
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
        self.navprof.image = UIImage(named: "Gradient")
        self.navprof.layer.cornerRadius = self.navprof.frame.width / 2
        NotificationCenter.default.addObserver(self, selector: #selector(ChatController.showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatController.hideKeyBoard(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row % 2 == 0) {
        let cell = tblvw.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
            cell.message.text = "tblvw.delegate = selftblvw.dataSource = selfself.tblvw.estimatedRowHeight = 100self.tblvw.rowHeight = UITableViewAutomaticDimension"
        cell.status.image = UIImage(named: "pending")
        cell.stamp.text = "20:30"
            
        return cell
        } else {
        let cell1 = tblvw.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
        cell1.message.text = "Jaadu"
        
        return cell1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func viewDidLayoutSubviews() {
        frame1 = vw.frame
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.tblvw.contentInset.bottom = height
            self.tblvw.scrollIndicatorInsets.bottom = height
            print(height)
            self.vw.frame = CGRect(x: frame1.origin.x, y: self.view.frame.height - height - frame1.height, width: frame1.width, height: frame1.height)
            if i > 0 {
                self.tblvw.scrollToRow(at: IndexPath.init(row: i - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    func hideKeyBoard(notification : Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.tblvw.contentInset.bottom = self.tblvw.contentInset.bottom - height
            self.vw.frame = frame1
            self.tblvw.scrollIndicatorInsets.bottom = self.tblvw.scrollIndicatorInsets.bottom - height
            self.tblvw.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .bottom, animated: true)
        }
    }

    
}
