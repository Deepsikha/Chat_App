//
//  SetProfileController.swift
//  Chat_App
//
//  Created by devloper65 on 4/19/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import PhotosUI

class SetProfileController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblAddphoto: UILabel!
    @IBOutlet var btnAddphoto: UIButton!
    @IBOutlet var btnDone: UIBarButtonItem!
    @IBOutlet var LblTitle: UINavigationItem!
    @IBOutlet var btnFacebook: UIButton!
    @IBOutlet var txfName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        self.imgProfile.layer.borderWidth = 1
        self.imgProfile.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        txfName.delegate = self

        //status bar color
        let statusBarBackground = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 0.7)
        statusBarBackground.backgroundColor = statusBarColor
        view.addSubview(statusBarBackground)
        
        //taphandle
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        self.imgProfile.image = UIImage(named: "default-user")
        UserDefaults.standard.set("default-user", forKey: "img")
    }
    
    override func viewDidLayoutSubviews() {
        self.imgProfile.layer.cornerRadius = imgProfile.frame.width / 2
    }

    //MARK:- TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text?.characters.count)! > 0 {
            self.btnDone.isEnabled = true
        } else {
            self.btnDone.isEnabled = false
        }
        textField.returnKeyType = UIReturnKeyType.done
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.characters.count == 1 && string == ""
        {
            self.btnDone.isEnabled = false
        } else {
            self.btnDone.isEnabled = true
        }
        return true
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if txfName.text != "" {
        self.btnDone.isEnabled = true
        }
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- ImagePicker Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            
        }
//        self.imgProfile.image = selectedImage
        UserDefaults.standard.set(info[UIImagePickerControllerReferenceURL] as? URL, forKey: "img")

//        self.imgProfile.image = imageFromAssetURL(assetURL: info[UIImagePickerControllerReferenceURL] as! NSURL)
        self.imgProfile.image = self.imageFromAssetURL(assetURL: info[UIImagePickerControllerReferenceURL] as! NSURL)
        self.lblAddphoto.isHidden = true
        dismiss(animated: true, completion: nil)
        
    }
    
    func imageFromAssetURL(assetURL: NSURL) -> UIImage {
        let assetUrl = URL(string: assetURL.absoluteString!)!
        
        // retrieve the list of matching results for your asset url
        let fetchResult = PHAsset.fetchAssets(withALAssetURLs: [assetUrl], options: nil)
        
        return getImage(asset: fetchResult.firstObject!)
        
    }
    
    func getImage(asset: PHAsset) -> UIImage
    {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        
        return thumbnail
    }
    
    //MARK:- Outlet Method
    @IBAction func handlebtnAddphoto(_ sender: Any) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func handleBtndone(_ sender: Any) {
        AppDelegate.senderDisplayName = self.txfName.text
        AppDelegate.pic = self.imgProfile.image
        server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "/profilecreation", Request_parameter: ["senderId" : AppDelegate.senderId , "username" : (txfName.text)!], Request_parameter_Images: ["file":self.imgProfile.image!] ,status: { (status) in
            
        }, response_Dictionary: { (dict) in
            if dict.value(forKey: "resp") as! String == "success" {
                UserDefaults.standard.set(self.txfName.text!,forKey: "nickName")
                let nav = HomeController()
                self.navigationController?.pushViewController(nav, animated: true)
            } else {
                Util.invokeAlertMethod("Failed", strBody: "Failed to update profile", delegate: self)
            }
            
        }, response_Array: { (arr) in
            
        }, isTokenEmbeded: false)
    }
    
    //MARK:- Custom Method
    func tapHandler() {
        self.txfName.resignFirstResponder()
    }
}
