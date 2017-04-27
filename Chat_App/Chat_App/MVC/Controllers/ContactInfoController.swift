//
//  ContactInfoController.swift
//  Chat_App
//
//  Created by Developer88 on 4/27/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class ContactInfoController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contact Info"
        let editbtn = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = editbtn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
