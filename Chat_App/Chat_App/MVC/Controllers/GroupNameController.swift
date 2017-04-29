//
//  GroupNameController.swift
//  Chat_App
//
//  Created by devloper65 on 4/26/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class GroupNameController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CheckedCollectionviewDelegate{
    
    @IBOutlet var imgGroup: UIImageView!
    @IBOutlet var btnPhoto: UIButton!
    @IBOutlet var collectionGroup: UICollectionView!
    @IBOutlet var txfGroupName: UITextField!
    @IBOutlet var lblCount: UILabel!
    var btnCreate:UIBarButtonItem!
    @IBOutlet var lblParticipant: UILabel!
    var count:Int = 25
    var txt:String!
    var media: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        
        txfGroupName.delegate = self
        collectionGroup.delegate = self
        collectionGroup.dataSource = self
        collectionGroup.register(UINib(nibName:"GroupAddCell",bundle:nil), forCellWithReuseIdentifier: "GroupAddCell")
        
        //Status Color
        let statusBarBackground = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 0.7)
        statusBarBackground.backgroundColor = statusBarColor
        view.addSubview(statusBarBackground)
        
    }
    
    override func viewDidLayoutSubviews() {
        self.imgGroup.layer.cornerRadius = imgGroup.frame.width / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "New Group"
        btnCreate = UIBarButtonItem(title: "Create", style: UIBarButtonItemStyle.done, target: self, action: #selector(create))
        self.navigationItem.rightBarButtonItem = btnCreate

    }
    //MARK:- TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField.text?.characters.count)! > 0 {
            self.btnCreate.isEnabled = true
        } else {
            self.btnCreate.isEnabled = false
        }
        textField.returnKeyType = UIReturnKeyType.done
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text?.characters.count == 1 && string == ""
        {
            self.btnCreate.isEnabled = false
            self.lblCount.text = "\(count)"
        } else {
            if string != "" {
                if (textField.text?.characters.count)! >= 24 {
                    //                    textField.text = textField.text! + string
                    if self.lblCount.text != "0" {
                        self.lblCount.text = "\((count - (textField.text?.characters.count)!)-1)"
                        txt = textField.text! + string
                    } else {
                        textField.text = txt
                    }
                } else {
                    self.btnCreate.isEnabled = true
                    self.lblCount.text = "\((count - (textField.text?.characters.count)!) - 1)"
                }
            } else {
                self.btnCreate.isEnabled = true
                self.lblCount.text = "\((count - (textField.text?.characters.count)!) + 1)"
            }
            
        }
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            self.btnCreate.isEnabled = true
        }
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- Collection Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionGroup.dequeueReusableCell(withReuseIdentifier: "GroupAddCell", for: indexPath) as! GroupAddCell
        cell.setUpCustom(collectionView: collectionView, indexPath: indexPath, CustomDelegate: self)
        
        cell.imgpic.image = UIImage(named: media[indexPath.item])
        return cell
        
    }
    
    func collectionView(_ collectionView : UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellSize: CGSize = CGSize(width: 70, height: 90)
        return cellSize
    }
    
    //MARK:- ImagePicker Delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            
        }
        self.imgGroup.image = selectedImage
        self.btnPhoto.setImage(nil, for: .normal)
        dismiss(animated: true, completion: nil)
        
    }
    
    //MARK: Outlet Method
    @IBAction func handleBtnPhoto(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK:- Custom Delegate
    func SettingsDidSelectCollectionViewCell(collectionView: UICollectionView, didSelectRowAtIndexPath indexPath: IndexPath) {
        self.media.remove(at: indexPath.row)
        self.collectionGroup.reloadData()
    }
    
    func create() {
        
    }
}
