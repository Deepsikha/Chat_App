//
//  welcome.swift
//  Chat_App
//
//  Created by devloper65 on 4/17/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class welcome: UIViewController {

    @IBOutlet var imgWelcome: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLayoutSubviews() {
        self.imgWelcome.layer.cornerRadius = imgWelcome.frame.width / 2
    }
    //Outlet Method
    @IBAction func btnAc(_ sender: Any) {
        let nav = Register()
        self.navigationController?.pushViewController(nav, animated: true)
    }
}
