//
//  Verification.swift
//  Chat_App
//
//  Created by devloper65 on 4/18/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class Verification: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var lblSendotp: UILabel!
    @IBOutlet var lblCall: UILabel!
    @IBOutlet var btnResend: UIButton!
    @IBOutlet var btnCall: UIButton!
    @IBOutlet var txfOTP: UITextField!
    @IBOutlet var txfOTP1: UITextField!
    @IBOutlet var txfOTP2: UITextField!
    @IBOutlet var txfOTP3: UITextField!
    @IBOutlet var txfOTP4: UITextField!
    @IBOutlet var txfOTP5: UITextField!
    @IBOutlet var txfOTP6: UITextField!
    
    static var no:String!
    var timer: Timer!;
    var counter: Int = 60;
    var total: Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txfOTP.delegate = self
        self.txfOTP.becomeFirstResponder()
        self.title = Verification.no
        self.navigationController?.isNavigationBarHidden = false
        self.lblCall.textColor = UIColor.lightGray
        self.lblSendotp.textColor = UIColor.lightGray
        self.timerStart()
    }
    
    //MARK:- TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.keyboardType = UIKeyboardType.numberPad
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            if txfOTP.text?.characters.count == 1 {
                txfOTP1.text = "-"
            } else if txfOTP.text?.characters.count == 2 {
                txfOTP2.text = "-"
            } else if txfOTP.text?.characters.count == 3 {
                txfOTP3.text = "-"
            } else if txfOTP.text?.characters.count == 4 {
                txfOTP4.text = "-"
            } else if txfOTP.text?.characters.count == 5 {
                txfOTP5.text = "-"
            } else if txfOTP.text?.characters.count == 6 {
                txfOTP6.text = "-"
            } else {
                return false
            }
        } else {
            if txfOTP.text?.characters.count == 0 {
                txfOTP1.text = string
            } else if txfOTP.text?.characters.count == 1 {
                txfOTP2.text = string
            } else if txfOTP.text?.characters.count == 2 {
                txfOTP3.text = string
            } else if txfOTP.text?.characters.count == 3 {
                txfOTP4.text = string
            } else if txfOTP.text?.characters.count == 4 {
                txfOTP5.text = string
            } else if txfOTP.text?.characters.count == 5 {
                txfOTP6.text = string
                self.lblSendotp.isEnabled = true
                self.lblCall.isEnabled = true
                self.timer.invalidate()
                self.validateOTP()
            } else {
                return false
            }
        }
        return true
    }
    
    //MARK:- Outlet Method
    @IBAction func handlebtnResend(_ sender: Any) {
        counter = 60;
        total = 0;
        self.timer = nil
        self.btnCall.isHidden = true
        self.btnResend.isHidden = true
        self.lblCall.isHidden = false
        self.lblSendotp.isHidden = false
        self.timerStart()
    }
    
    @IBAction func handlebtnCall(_ sender: Any) {
        self.btnCall.isHidden = true
        self.btnResend.isHidden = true
        self.lblCall.isHidden = false
        self.lblSendotp.isHidden = false
    }
    
    //MARK:- Custom Method
    func timerStart() {
        if(timer == nil) {
            timer = Timer.init(timeInterval: 1, target: self, selector: #selector(Verification.timerFunction(_:)), userInfo: nil, repeats: true);
            let runloop: RunLoop = RunLoop.current;
            runloop.add(timer, forMode: RunLoopMode.defaultRunLoopMode);
        }
    }
    
    func timerFunction(_ atimer:Timer) {
        counter -= 1;
        lblSendotp.text = "Resend Code in 0:\(counter)"
        lblCall.text = "Call Me in 0:\(counter)"
        
        if(counter == total) {
            timer.invalidate();
            self.btnCall.isHidden = false
            self.btnResend.isHidden = false
            self.lblCall.isHidden = true
            self.lblSendotp.isHidden = true
        }
    }
    
    func validateOTP() {
        //code here to verify OTP
        let nav = SetProfileController()
        self.navigationController?.pushViewController(nav, animated: true)
    }
}
