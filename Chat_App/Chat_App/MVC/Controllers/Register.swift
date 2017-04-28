//
//  Register.swift
//  Chat_App
//
//  Created by devloper65 on 4/17/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class Register: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var lblCCode: UILabel!
    @IBOutlet var txfNumber: UITextField!
    @IBOutlet var btnCountry: UIButton!
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var lblConnect: UILabel!
    
    var transperentView = UIView()
    var cView: UIView!
    static var cName:String!
    static var cCode:String!
    var btn : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txfNumber.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        self.indicator.isHidden = true
        self.title = "Edit number"
        
        //taphandle
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        //status bar color
        let statusBarBackground = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 0.7)
        statusBarBackground.backgroundColor = statusBarColor
        view.addSubview(statusBarBackground)
        self.txfNumber.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = false
        btn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItem = btn
        self.indicator.isHidden = true
        self.txfNumber.becomeFirstResponder()
        if Register.cName != nil {
            self.btnCountry.setTitle(Register.cName, for: UIControlState.normal)
            self.lblCCode.text = "+\(Register.cCode!)"
        }
        if(txfNumber.text != "") {
            self.title = self.lblCCode.text?.appending(" ").appending(self.txfNumber.text!)
        }
    }
    
    override func viewDidLayoutSubviews() {

    }
    
    //MARK:- TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.keyboardType = UIKeyboardType.numberPad
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.characters.count != 0 {
            self.title = lblCCode.text! + " " + textField.text!
        } else {
            self.title = "Your Phone Number"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.characters.count == 1 && string == ""
        {
            self.title = "Your Phone Number"
        } else {
            self.title =  lblCCode.text! + " " + textField.text! + "\(string)"
            if string == "" {
                self.title = (self.title! as NSString).substring(to: (self.title! as NSString).length - 1)
                if isValidNumber(textField.text!, length: 11) {
                    self.btn.isEnabled = true
                } else {
                    self.btn.isEnabled = false
                }
            } else {
                if isValidNumber(textField.text!, length: 9) {
                    
                    self.btn.isEnabled = true
                } else {
                    self.btn.isEnabled = false
                }
            }
            }
        
            
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isValidNumber(textField.text!, length: 10) {
            textField.textColor = UIColor.black
            self.btn.isEnabled = true
            textField.resignFirstResponder()
        } else {
            textField.textColor = UIColor.red
        }
        return true
    }
    
    //MARK:- Outlet Method
    
    
    @IBAction func handlebtnCountry(_ sender: Any) {
        let nav = CountryList()
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    //MARK:- Custom Method
    
    func done() {
        self.txfNumber.resignFirstResponder()
        self.btn.isEnabled = false
        let alert = UIAlertController(title: "NUMBER CONFIRMATION: \n\n \(self.lblCCode.text!) \(self.txfNumber.text!) \n\nIs your phone number above correct?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let blur = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let blurView = UIVisualEffectView(effect: blur)
            blurView.alpha = 0.9
            blurView.frame = self.view.bounds
            blurView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
            self.view.addSubview(blurView)
            self.indicator.isHidden = false
            self.lblConnect.isHidden = false
            self.indicator.startAnimating()
            blurView.addSubview(self.indicator)
            blurView.addSubview(self.lblConnect)
            
            let no = "+\(self.lblCCode.text!)\(self.txfNumber.text!)"
            let parameters = ["userId": no] as Dictionary<String, String>
            server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "/register", Request_parameter: parameters, Request_parameter_Images: nil, status: { (results) in
                
            }, response_Dictionary: { (res) in
                DispatchQueue.main.async {
                    print(res)
                    if res.value(forKey: "resp") as! String == "success" {
                        self.indicator.stopAnimating()
                        self.transperentView.removeFromSuperview()
                        
                        blurView.removeFromSuperview()
                        let nav = Verification()
                        self.navigationController?.pushViewController(nav, animated: true)
                        self.title = "Edit Number"
                    } else {
                        
                    }
                }
            }, response_Array: { (resArr) in
                
            }, isTokenEmbeded: false)
            
        })
        Verification.no = "\(self.lblCCode.text!)\(txfNumber.text!)"
        
        alert.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            self.txfNumber.becomeFirstResponder()
            print("confirm Pressed")
            
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func tapHandler() {
        self.txfNumber.resignFirstResponder()
    }
    
    func isValidNumber(_ data:String,length:Int?) -> Bool{
        let ns:NSString
        if let _ = length{
            ns = "[0-9]{\(length!)}" as NSString
        }else{
            ns = "[0-9]+"
        }
        let pr:NSPredicate = NSPredicate(format: "SELF MATCHES %@",ns)
        return pr.evaluate(with: data)
    }
}
