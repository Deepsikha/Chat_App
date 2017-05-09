//
//  Verification.swift
//  Chat_App
//
//  Created by devloper65 on 4/18/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class Verification: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var lblverify: UILabel!
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
    var blurView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txfOTP.delegate = self
        self.txfOTP.becomeFirstResponder()
        self.title = Verification.no
        self.navigationController?.isNavigationBarHidden = false
        self.lblCall.textColor = UIColor.lightGray
        self.lblSendotp.textColor = UIColor.lightGray
        self.indicator.isHidden = true
        self.timerStart()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
                self.txfOTP.text = self.txfOTP.text! + string
                self.lblSendotp.isEnabled = true
                self.lblCall.isEnabled = true
                self.timer.invalidate()
                self.validateOTP()
                
                let blur = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
                blurView = UIVisualEffectView(effect: blur)
                blurView.alpha = 0.9
                blurView.frame = self.view.bounds
                blurView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
                self.view.addSubview(blurView)
                self.indicator.isHidden = false
                self.lblverify.isHidden = false
                self.lblverify.text = "Verifying \(Verification.no!)"
                self.indicator.startAnimating()
                blurView.addSubview(self.indicator)
                blurView.addSubview(self.lblverify)
                
                self.txfOTP.resignFirstResponder()
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
        
        let no = Verification.no
        let parameters = ["userId": no] as! Dictionary<String, String>
        server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "/register", Request_parameter: parameters, Request_parameter_Images: nil, status: { (results) in
            
        }, response_Dictionary: { (res) in
            DispatchQueue.main.async {
                
                if res.value(forKey: "resp") as! String == "success" {
                    let nav = Verification()
                    AppDelegate.senderId = Verification.no
                    self.navigationController?.pushViewController(nav, animated: true)
                
                } else {
                    self.blurView.removeFromSuperview()
                }
            }
        }, response_Array: { (resArr) in
            
        }, isTokenEmbeded: false)
        
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
        
        if counter < 10 {
            lblSendotp.text = "Resend Code in 0:0\(counter)"
            lblCall.text = "Call Me in 0:0\(counter)"
        }
        
        if(counter == total) {
            timer.invalidate();
            self.btnCall.isHidden = false
            self.btnResend.isHidden = false
            self.lblCall.isHidden = true
            self.lblSendotp.isHidden = true
        }
    }
    
    func validateOTP() {
        let param:[String:String] = ["onetimepassword": self.txfOTP.text! , "userId": Verification.no]
        server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "/verification", Request_parameter: param, Request_parameter_Images: nil, status: { (st) in
            
        }, response_Dictionary: { (res) in
            DispatchQueue.main.async {
            print(res)
            if res.value(forKey: "resp") as! String == "success" {
                UserDefaults.standard.set(Verification.no, forKey: "id")
                AppDelegate.senderId = Verification.no
                self.indicator.stopAnimating()
                let nav = SetProfileController()
                self.navigationController?.pushViewController(nav, animated: true)
            } else {
                
            }
            }
        }, response_Array: { (arr) in
            
        }, isTokenEmbeded: false)        
    }
}
