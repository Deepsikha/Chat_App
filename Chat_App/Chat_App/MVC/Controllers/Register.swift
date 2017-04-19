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
    
    @IBOutlet var lblTitle: UINavigationItem!
    
    @IBOutlet var btnDone: UIBarButtonItem!
    
    @IBOutlet var viewCountry: UIView!
    
    @IBOutlet var navDone: UINavigationBar!
    
    var transperentView = UIView()
    var cView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        txfNumber.delegate = self
        self.navigationController?.isNavigationBarHidden = true
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.txfNumber.becomeFirstResponder()

    }
    //MARK:- TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.keyboardType = UIKeyboardType.numberPad
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.characters.count != 0 {
            self.lblTitle.title = lblCCode.text! + " " + textField.text!
        } else {
            self.lblTitle.title = "Your Phone Number"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text?.characters.count == 1 && string == ""
        {
            self.lblTitle.title = "Your Phone Number"
        } else {
            self.lblTitle.title =  lblCCode.text! + " " + textField.text! + "\(string)"
            if string == "" {
                self.lblTitle.title?.remove(at: (self.lblTitle.title?.index(before: (self.lblTitle.title?.endIndex)!))!)
            }
        }
        if string == "" {
            if isValidNumber(textField.text!, length: 11) {
                self.btnDone.isEnabled = true
            } else {
                self.btnDone.isEnabled = false
            }
        } else {
            if isValidNumber(textField.text!, length: 9) {

                self.btnDone.isEnabled = true
            } else {
                self.btnDone.isEnabled = false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if isValidNumber(textField.text!, length: 10) {
            textField.textColor = UIColor.black
            self.btnDone.isEnabled = true
            textField.resignFirstResponder()
        } else {
            textField.textColor = UIColor.red
        }
        return true
    }
    //MARK:- Outlet Method
    
    @IBAction func handleBtnDone(_ sender: Any) {
        
        let alert = UIAlertController(title: "NUMBER CONFIRMATION: \n\n \(self.lblCCode.text!) \(self.txfNumber.text!) \n\nIs your phone number above correct?", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let nav = Verification()
            self.navigationController?.pushViewController(nav, animated: true)
            print("yes Pressed")
        })
        Verification.no = self.lblCCode.text! + " " + txfNumber.text!
        
        alert.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            self.txfNumber.becomeFirstResponder()
            print("confirm Pressed")
            
        })
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //MARK:- Custom Method
    
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
