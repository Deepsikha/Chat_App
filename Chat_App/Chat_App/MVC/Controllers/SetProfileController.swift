//
//  SetProfileController.swift
//  Chat_App
//
//  Created by devloper65 on 4/19/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import PhotosUI
import Contacts
import FBSDKLoginKit
import SDWebImage

class SetProfileController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SDWebImageManagerDelegate {

    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var lblAddphoto: UILabel!
    @IBOutlet var btnAddphoto: UIButton!
    @IBOutlet var btnDone: UIBarButtonItem!
    @IBOutlet var LblTitle: UINavigationItem!
    
    @IBOutlet var txfName: UITextField!
    
    var dict = [String: String]()
    var store = CNContactStore()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.getContact()
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
    
    @IBAction func btnFBLoginPressed(_ sender: AnyObject) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    
    func getFBUserData(){
        var dictInfo : [String : AnyObject]!
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    dictInfo = result as! [String : AnyObject]
                    
                    let url = URL(string: (dictInfo!["picture"]!["data"]!! as AnyObject).value(forKey: "url")! as! String)
                    self.imgProfile.sd_setImage(with: url!, placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, completed: { (image, error, memory, imageUrl) in
                        self.lblAddphoto.isHidden = true
                        self.txfName.text = dictInfo!["name"] as? String
                        self.btnDone.isEnabled = true
                    })
                }
            })
        }
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
        UserDefaults.standard.set(info[UIImagePickerControllerReferenceURL] as? String, forKey: "img")

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
//        AppDelegate.senderDisplayName = self.txfName.text
//        AppDelegate.pic = self.imgProfile.image
//        server_API.sharedObject.requestFor_NSMutableDictionary(Str_Request_Url: "/profilecreation", Request_parameter: ["senderId" : AppDelegate.senderId , "username" : (txfName.text)!], Request_parameter_Images: ["file":self.imgProfile.image!] ,status: { (status) in
//            
//        }, response_Dictionary: { (dict) in
//            if dict.value(forKey: "resp") as! String == "success" {
//                UserDefaults.standard.set(self.txfName.text!,forKey: "nickName")
//                let nav = HomeController()
//                self.navigationController?.pushViewController(nav, animated: true)
//            } else {
//                Util.invokeAlertMethod("Failed", strBody: "Failed to update profile", delegate: self)
//            }
//            
//        }, response_Array: { (arr) in
//            
//        }, isTokenEmbeded: false)
        self.navigationController?.pushViewController(HomeController(), animated: true)

    }
    
    //MARK:- Custom Method
    func tapHandler() {
        self.txfName.resignFirstResponder()
    }
    
    func getContact() {
        var contactNumber:[String] = []
        store.requestAccess(for: .contacts, completionHandler: {
            granted, error in
            
            guard granted else {
                let alert = UIAlertController(title: "Can't access contact", message: "Please go to Settings -> MyApp to enable contact permission", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any]
            let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
            var cnContacts = [CNContact]()
            
            do {
                try self.store.enumerateContacts(with: request){
                    (contact, cursor) -> Void in
                    cnContacts.append(contact)
                }
            } catch let error {
                NSLog("Fetch contact error: \(error)")
            }
            
            for contact in cnContacts {
                var MobNumVar:String!
                for ContctNumVar: CNLabeledValue in contact.phoneNumbers
                {
                    
                    let FulMobNumVar  = ContctNumVar.value
                    let MccNamVar = FulMobNumVar.value(forKey: "countryCode") as? String
                    let code = Countries.countryInfoDictionary[MccNamVar!.uppercased()]?["phoneExtension"] as! String
                    MobNumVar = FulMobNumVar.value(forKey: "digits") as? String
                    contactNumber.append(MobNumVar!)
                }
                if(MobNumVar != nil) {
                    
                    self.dict[MobNumVar] = contact.givenName
                }
            }
            self.register(contactNumber)
        })
        
    }
    
    func register(_ Arr : [String])
    {
        server_API.sharedObject.requestFor_NSMutableDictionaryMine(Str_Request_Url: "/contactCheck", Request_parameter: ["users" : Arr], Request_parameter_Images: nil, status: { (status) in
            print(status)
        }, response_Dictionary: { (resp) in
            print("resp:\(resp)")
        }, response_Array: { (arr) in
            print(arr)
            
            for i in arr {
                let a = i as AnyObject
                let no = String(describing :a.value(forKey: "number")!)
                _ = ModelManager.getInstance().addData("user", "user_id,nick_name,status_user,lastseen,country,time_zone,profile_pic,profile_thumb,username", "\(String(describing: a.value(forKey: "number")!)),\'\(String(describing: a.value(forKey: "nick_name")!))\',\'\(String(describing: a.value(forKey: "status_user")!))\',\(String(describing: a.value(forKey: "lastseen")!)),\'\(String(describing: a.value(forKey: "country")!))\',\'\(String(describing: a.value(forKey: "time_zone")!))\',\'\(String(describing: a.value(forKey: "profile_pic")!))\',\'\(String(describing: a.value(forKey: "profile_thumb")!))\',\'\(String(describing: self.dict[no]!))\'")
            }
        }, isTokenEmbeded: false)
    }
}
