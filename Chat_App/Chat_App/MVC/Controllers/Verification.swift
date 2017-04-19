//
//  Verification.swift
//  Chat_App
//
//  Created by devloper65 on 4/18/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class Verification: UIViewController {
    
    static var no:String!
    var timer: Timer!;
    var counter: Int = 60;
    var total: Int = 0;
    @IBOutlet var lblSendotp: UILabel!
    @IBOutlet var lblCall: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Verification.no
        self.navigationController?.isNavigationBarHidden = false
        self.lblCall.textColor = UIColor.lightGray
        self.lblSendotp.textColor = UIColor.lightGray
        
        if(timer == nil) {
            timer = Timer.init(timeInterval: 1, target: self, selector: #selector(Verification.timerFunction(_:)), userInfo: nil, repeats: true);
            let runloop: RunLoop = RunLoop.current;
            runloop.add(timer, forMode: RunLoopMode.defaultRunLoopMode);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timerFunction(_ atimer:Timer) {
        counter -= 1;
        lblSendotp.text = "Resend Code in 0:\(counter)"
        lblCall.text = "Call Me in 0:\(counter)"
        
        if(counter == total) {
            timer.invalidate();
        }
    }

}
