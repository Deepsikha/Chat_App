//
//  AppDelegate.swift
//  Chat_App
//
//  Created by devloper65 on 4/17/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import SocketRocket
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var websocket: SRWebSocket!
    static var senderId = "8454644"
    static var senderDisplayName:String!
    static var pic:UIImage!
    
    static let app = UIApplication.shared
    static var count : Int!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        Util.copyFile("Socket_chat.sqlite")
        Fabric.with([Crashlytics.self()])
        self.logUser()
        
        if(UserDefaults.standard.value(forKey: "id") == nil) {
            
            let rootVC = NewGroupController()
            let nav = UINavigationController(rootViewController: rootVC)
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
            return true
        }
        else{
            let rootVC = HomeController()
            let nav = UINavigationController(rootViewController: rootVC)
            window?.rootViewController = nav
            window?.makeKeyAndVisible()
            return true
        }
        
}
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print(token)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func logUser() {
        
        Crashlytics.sharedInstance().setUserEmail("lanetteam.milans@gmail.com")
        Crashlytics.sharedInstance().setUserIdentifier("Developer")
        Crashlytics.sharedInstance().setUserName("Prime User")
    }


}

