//
//  HomeController.swift
//  Chat_App
//
//  Created by Developer88 on 4/17/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class HomeController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        tabBarController?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.selectedIndex = 2

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let tabOne = StatusController()
        tabOne.tabBarItem = UITabBarItem(title: "Status", image: UIImage(named: ""), tag: 1)
        
        let tabTwo = CallsController()
        tabTwo.tabBarItem = UITabBarItem(title: "Calls", image: UIImage(named: "Calls"), tag: 2)
        
        let tabThree = CameraController()
        tabThree.tabBarItem = UITabBarItem(title: "Camera", image: UIImage(named: "Camera"), tag: 3)
        
        let tabFour = ChatController()
        tabFour.tabBarItem = UITabBarItem(title: "Chats", image: UIImage(named: "chaticon"), tag: 4)
        
        let tabFive = SettingsController()
        tabFive.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "Settings"), tag: 5)
        self.viewControllers = [tabOne,tabTwo,tabThree,tabFour,tabFive]
        
        //tabBarController?.selectedViewController = ChatController()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK :- Tabbar Methods
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch viewController {
        case is ChatController:
            self.title = "Chat"
            let button1 = UIBarButtonItem(image: UIImage(named: "Edit"), style: .plain, target: self, action: #selector(ChatController.edit))
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItem = button1
            break
        case is StatusController:
            self.title = "Status"
            self.navigationItem.titleView = nil
            let button1 = UIBarButtonItem(image: UIImage(named: "AddStatus"), style: .plain, target: self, action: #selector(ChatController.edit))
            self.navigationItem.rightBarButtonItem = button1
            break
        case is CallsController:
            self.title = "Calls"
            let button1 = UIBarButtonItem(image: UIImage(named: "Calls"), style: .plain, target: self, action: #selector(ChatController.edit))
            self.navigationItem.rightBarButtonItem = button1
            let segment: UISegmentedControl = UISegmentedControl(items: ["All", "Missed"])
            segment.sizeToFit()
            segment.selectedSegmentIndex = 0
            self.navigationItem.titleView = segment
            break
        case is CameraController:
            self.title = "Camera"
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.titleView = nil
            break
        case is SettingsController:
            self.title = "Settings"
            self.navigationItem.titleView = nil
            self.navigationItem.rightBarButtonItem = nil
            break
        default:
            print("")
        }
    }
    

}
