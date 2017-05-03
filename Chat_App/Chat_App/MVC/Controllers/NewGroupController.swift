//
//  NewGroupController.swift
//  Chat_App
//
//  Created by Developer88 on 4/25/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import Contacts
import SDWebImage
class NewGroupController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, CheckedTableviewDelegate, CheckedCollectionviewDelegate {

    @IBOutlet var searchMember: UISearchBar!
    @IBOutlet var tblContactList: UITableView!
    @IBOutlet var collectionPerson: UICollectionView!
    
    let store = CNContactStore()
    var contactList: NSArray!
    var contactListGrouped = NSDictionary() as! [String : NSArray]
    var sectionTitleList = [String]()
    var label1:UILabel!
    var media = NSArray()
    var user = [User]()
    var id: Int!
    var selectedIndex:[IndexPath] = []
    var count: Int! = 0 //for id

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        collectionPerson.delegate = self
        collectionPerson.dataSource = self
        collectionPerson.register(UINib(nibName: "GroupAddCell", bundle: nil), forCellWithReuseIdentifier: "GroupAddCell")
        
        tblContactList.delegate = self
        tblContactList.dataSource = self
        tblContactList.register(UINib(nibName: "GroupTableCell", bundle: nil), forCellReuseIdentifier: "GroupTableCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let nxt = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.done, target: self, action: #selector(nextpage))
        self.navigationItem.rightBarButtonItem = nxt
        
        let cnl = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = cnl
        
        let vw = UIView(frame: CGRect(x: ((UIScreen.main.bounds.width/2) - 100), y: 0, width: 200, height: 44))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        label.textAlignment = NSTextAlignment.center
        label.text = "Add Paticipants"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        label1 = UILabel(frame: CGRect(x: 0, y: 30, width: 200, height: 14))
        label1.textAlignment = NSTextAlignment.center
        label1.textColor = UIColor.gray

        vw.addSubview(label)
        vw.addSubview(label1)
        
        self.navigationItem.titleView = vw
        
        self.contactList = NSArray(array: ModelManager.getInstance().getAllData("user"))
        self.contactList = self.contactList.sorted(by: { (a, b) -> Bool in
            return ((a as! NSDictionary)["username"]! as! String) < ((b as! NSDictionary)["username"]! as! String)
        }) as NSArray
        splitDataInToSection()
        print(contactList!)
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
        let cell = collectionPerson.dequeueReusableCell(withReuseIdentifier: "GroupAddCell", for: indexPath) as! GroupAddCell
        cell.setUpCustom(collectionView: collectionView, indexPath: indexPath, CustomDelegate: self)
        cell.imgpic.sd_setImage(with: URL(string: ((media.object(at: 0) as AnyObject).value(forKey: "profile_thumb")! as? String)! ), placeholderImage: UIImage(named: "default-user"), options: SDWebImageOptions.progressiveDownload, completed: { (image, error, memory, imageUrl) in
            
        })
//        cell.imgpic.image = UIImage(named: ((media?.object(at: 0) as AnyObject).value(forKey: "username")! as? String)!)
        cell.lblName.text = (media.object(at: 0) as AnyObject).value(forKey: "username")! as? String

        return cell
        
    }
    
    func collectionView(_ collectionView : UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellSize: CGSize = CGSize(width: 70, height: 90)
        return cellSize
    }
    
    //MARK:- Table Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        if contactListGrouped.count != 0 {
            return self.contactListGrouped.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = self.sectionTitleList[section]
        let contacts = self.contactListGrouped[sectionTitle]
        return contacts!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableCell", for: indexPath) as! GroupTableCell
        
        cell.setUpCustom(tableView: tableView, indexPath: indexPath, CustomDelegate: self)
        let sectionTitle = self.sectionTitleList[(indexPath as NSIndexPath).section]
        let contacts = self.contactListGrouped[sectionTitle]
            cell.lblName?.text = (contacts?.object(at: 0) as AnyObject).value(forKey: "username")! as? String
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return self.sectionTitleList[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
            return self.sectionTitleList
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
            return index
    }

    //MARK:- Custom Method 
    
    fileprivate func splitDataInToSection() {
        var sectionTitle: String = ""
            for i in 0..<self.contactList.count {
                
                let currentRecord = self.contactList.object(at: i)
                let firstChar = ((currentRecord as AnyObject).value(forKey: "username")! as! String).characters.first
                let firstCharString = "\(String(describing: firstChar!))"
                if firstCharString != sectionTitle {
                    sectionTitle = firstCharString
                    self.contactListGrouped[sectionTitle] = NSArray()
                    self.sectionTitleList.append(sectionTitle)
                }
                self.contactListGrouped[firstCharString] = self.contactListGrouped[firstCharString]?.adding(currentRecord) as NSArray?
            }
        
        DispatchQueue.main.async {
            self.tblContactList.reloadData()
            
        }
    }
    
    func nextpage() {
        let vw = GroupNameController()
        vw.media = self.media
        self.navigationController?.pushViewController(vw, animated: true)
        
    }
    
    func cancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //Custom Delegate
    func SettingsDidSelectTableViewCell(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath, type: String) {
        let sectionTitle = self.sectionTitleList[(indexPath as NSIndexPath).section]
        
        let contacts = self.contactListGrouped[sectionTitle]
        let name = contacts?.object(at: indexPath.row)
        if type == "Checked" {
            self.media = self.media.adding(name!) as NSArray
            self.selectedIndex.append(indexPath)
            self.label1.text = "\(media.count) / 256"
        } else {
            self.selectedIndex = self.selectedIndex.filter{$0 != indexPath}
            self.media = self.media.filter({ (a) -> Bool in
                (a as! NSDictionary)["username"]! as! String != (name as! NSDictionary)["username"]! as! String
            }) as NSArray
            self.label1.text = "\(media.count) / 256"
        }
        self.collectionPerson.reloadData()
    }
    
    func SettingsDidSelectCollectionViewCell(collectionView: UICollectionView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let index = selectedIndex[indexPath.item]
        let cell1 = self.tblContactList.cellForRow(at: index) as! GroupTableCell
        cell1.btnRight.tag = 0
        cell1.btnRight.setImage(UIImage(named: ""), for: .normal)
        cell1.Celldelegate.SettingsDidSelectTableViewCell!(tableView: self.tblContactList, didSelectRowAtIndexPath: index, type: "unChecked")
        self.media = self.media.filter({ (a) -> Bool in
            (a as! NSDictionary)["username"]! as! String != (self.media.object(at: indexPath.item) as! NSDictionary)["username"]! as! String
        }) as NSArray
        self.tblContactList.reloadData()
        self.collectionPerson.reloadData()
    }
    

}
