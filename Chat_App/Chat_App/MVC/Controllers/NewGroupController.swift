//
//  NewGroupController.swift
//  Chat_App
//
//  Created by Developer88 on 4/25/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import Contacts

class NewGroupController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, CheckedTableviewDelegate, CheckedCollectionviewDelegate {

    @IBOutlet var searchMember: UISearchBar!
    @IBOutlet var tblContactList: UITableView!
    @IBOutlet var collectionPerson: UICollectionView!
    
    let store = CNContactStore()
    var contactList: [String] = Array()
    var contactListGrouped = NSDictionary() as! [String : [String]]
    var sectionTitleList = [String]()
    var label1:UILabel!
    var media: [String] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        collectionPerson.delegate = self
        collectionPerson.dataSource = self
        collectionPerson.register(UINib(nibName: "GroupAddCell", bundle: nil), forCellWithReuseIdentifier: "GroupAddCell")
        
        tblContactList.delegate = self
        tblContactList.dataSource = self
        tblContactList.register(UINib(nibName: "GroupTableCell", bundle: nil), forCellReuseIdentifier: "GroupTableCell")
        DispatchQueue.main.async {
            self.getContact()
        }
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
        cell.imgpic.image = UIImage(named: self.media[indexPath.item])
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
            cell.lblName?.text = contacts![(indexPath as NSIndexPath).row]
       
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
            
            let currentRecord = self.contactList[i]
            let firstChar = currentRecord[currentRecord.startIndex]
            let firstCharString = "\(firstChar)"
            if firstCharString != sectionTitle {
                sectionTitle = firstCharString
                self.contactListGrouped[sectionTitle] = [String]()
                self.sectionTitleList.append(sectionTitle)
            }
            self.contactListGrouped[firstCharString]?.append(currentRecord)
        }
        self.tblContactList.reloadData()
        
    }
    
    func getContact() {
        
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
                self.contactList.append(contact.givenName)
                
                for ContctNumVar: CNLabeledValue in contact.phoneNumbers
                {
                    let FulMobNumVar  = ContctNumVar.value
                    let MccNamVar = FulMobNumVar.value(forKey: "countryCode") as? String
                    let MobNumVar = FulMobNumVar.value(forKey: "digits") as? String
                }
            }
            self.contactList = self.contactList.sorted()
            DispatchQueue.main.async {
                self.splitDataInToSection()
            }
        })
    }
    
    func nextpage() {
        let vw = GroupNameController()
        vw.media = self.media
        self.navigationController?.pushViewController(vw, animated: true)
        
    }
    
    func cancel() {
        
    }
    
    //Custom Delegate
    func SettingsDidSelectTableViewCell(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath, type: String) {
        let sectionTitle = self.sectionTitleList[(indexPath as NSIndexPath).section]
        let contacts = self.contactListGrouped[sectionTitle]
        let name = contacts![(indexPath as NSIndexPath).row]
        if type == "Checked" {
            self.media.append(name)
        } else {
            self.media = self.media.filter{$0 != name}
        }
        self.collectionPerson.reloadData()
    }
    
    func SettingsDidSelectCollectionViewCell(collectionView: UICollectionView, didSelectRowAtIndexPath indexPath: IndexPath) {
        self.media.remove(at: indexPath.row)
        self.collectionPerson.reloadData()
    }

}
