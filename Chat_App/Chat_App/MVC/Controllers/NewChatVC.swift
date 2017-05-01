//
//  NewChatVC.swift
//  Chat_App
//
//  Created by devloper65 on 4/20/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import Contacts

class NewChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet var tblNewContact: UITableView!
    @IBOutlet var searchContact: UISearchBar!
    @IBOutlet var vwHeader: UIView!
    @IBOutlet var btnCancel: UIBarButtonItem!
    @IBOutlet var tblHeader: UITableView!
    
    var caller: String!
    let store = CNContactStore()
    var contactList: [String] = Array()
    var contactListGrouped = NSDictionary() as! [String : [String]]
    var sectionTitleList = [String]()
    var filteredContactList: [String] = Array()
    var filtercontactListGrouped = NSDictionary() as! [String : [String]]
    var filtersectionTitleList = [String]()
    var isSearch:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblNewContact.delegate = self
        tblNewContact.dataSource = self
        tblHeader.delegate = self
        tblHeader.dataSource = self
        searchContact.delegate = self
        if caller == "ChatListController" {
            self.title = "New Chat"
        } else {
            self.title = "New Call"
 
        }
        self.navigationController?.isNavigationBarHidden = true
        
        self.tblNewContact.register(UINib(nibName: "NewChatCell", bundle: nil), forCellReuseIdentifier: "NewChatCell")
        self.tblHeader.register(UINib(nibName: "NewChatHeaderCell", bundle: nil), forCellReuseIdentifier: "NewChatHeaderCell")
        self.tblNewContact.register(UINib(nibName: "CallCell", bundle: nil), forCellReuseIdentifier: "CallCell")
        //taphandle
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        //status bar color
        let statusBarBackground = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 0.7)
        statusBarBackground.backgroundColor = statusBarColor
        view.addSubview(statusBarBackground)
        self.tblNewContact.tableHeaderView = self.vwHeader
        self.getContact()
        self.searchContact.placeholder = "Search"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tblNewContact.register(UINib(nibName: "NewChatCell", bundle: nil), forCellReuseIdentifier: "NewChatCell")
        self.tblHeader.register(UINib(nibName: "NewChatHeaderCell", bundle: nil), forCellReuseIdentifier: "NewChatHeaderCell")
        self.tblNewContact.register(UINib(nibName: "CallCell", bundle: nil), forCellReuseIdentifier: "CallCell")
    }
    // MARK: - Table Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int {
        if !(self.caller.isEmpty) {
            if self.caller! == "ChatListController" {
                if tableView == tblHeader {
                    return 1
                } else {
                    if self.isSearch {
                        return self.filtercontactListGrouped.count
                    } else {
                        return self.contactListGrouped.count
                    }
                }
            } else {
                return self.contactListGrouped.count
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblHeader {
            return 2
        } else {
            if isSearch {
            let sectionTitle = self.filtersectionTitleList[section]
            let contacts = self.filtercontactListGrouped[sectionTitle]
            return contacts!.count
            } else {
                let sectionTitle = self.sectionTitleList[section]
                let contacts = self.contactListGrouped[sectionTitle]
                return contacts!.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if caller == "ChatListController" {
            if tableView == tblHeader {
                let cell:NewChatHeaderCell = tableView.dequeueReusableCell(withIdentifier: "NewChatHeaderCell", for: indexPath) as! NewChatHeaderCell
                if indexPath.row == 0 {
                    cell.img.image = UIImage(named: "group")
                    cell.btn.setTitle("New Group", for: UIControlState.normal)
                } else {
                    cell.img.image = UIImage(named: "contact")
                    cell.btn.setTitle("New Contact", for: UIControlState.normal)
                }
                return cell
            } else {
                let cell:NewChatCell = (tableView.dequeueReusableCell(withIdentifier: "NewChatCell", for: indexPath) as? NewChatCell)!
                if isSearch {
                    let sectionTitle = self.filtersectionTitleList[(indexPath as NSIndexPath).section]
                    let contacts = self.filtercontactListGrouped[sectionTitle]
                    cell.lblContact?.text = contacts![(indexPath as NSIndexPath).row]
                    cell.lblStatus.text = ""
                } else {
                    let sectionTitle = self.sectionTitleList[(indexPath as NSIndexPath).section]
                    let contacts = self.contactListGrouped[sectionTitle]
                    cell.lblContact?.text = contacts![(indexPath as NSIndexPath).row]
                    cell.lblStatus.text = ""
                }
                
                return cell
            }
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CallCell", for: indexPath) as! CallCell
            self.tblNewContact.tableHeaderView = nil
            let sectionTitle = self.sectionTitleList[(indexPath as NSIndexPath).section]
            let contacts = self.contactListGrouped[sectionTitle]
            cell.lblCallPerson?.text = contacts![(indexPath as NSIndexPath).row]
            cell.lblLastCallStatus.text = ""
            
            cell.imgCalltype.image = UIImage(named: "incomingcall")
            cell.imgCalltype.image = cell.imgCalltype.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            cell.imgCalltype.tintColor = UIColor.green
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == tblNewContact {
            if isSearch {
                return self.filtersectionTitleList[section]
            }else {
                return self.sectionTitleList[section]
            }
        } else {
            return nil
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if tableView == tblNewContact {
            if isSearch {
                return self.filtersectionTitleList
            } else {
                return self.sectionTitleList
            }
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if tableView == tblNewContact {
            return index
        } else {
            return 0
        }
    }
    
    //MARK:- Search Delegate 
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            if isSearch == true{
                isSearch = false
                tblNewContact.reloadData()
            }
            searchBar.text = ""
        self.searchContact.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.isEmpty)!{
            isSearch = false
            tblNewContact.reloadData()
        } else {
            isSearch = true
            filt()
            splitDataInToSection()
        }
    }
    
    func filt()
    {
        filteredContactList.removeAll(keepingCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", self.searchContact.text!)
        let array = (contactList as NSArray).filtered(using: searchPredicate)
        filteredContactList = array as! [String]

    }
    //MARK:- Outlet Method
    @IBAction func handleBtncancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Custom Method
    func tapHandler() {
        self.searchContact.resignFirstResponder()
    }
    
    fileprivate func splitDataInToSection() {
        var sectionTitle: String = ""
        if isSearch {
            self.filtercontactListGrouped.removeAll()
            self.filtersectionTitleList.removeAll()
            for i in 0..<self.filteredContactList.count {
                let currentRecord = self.filteredContactList[i]
                let firstChar = currentRecord[currentRecord.startIndex]
                let firstCharString = "\(firstChar)"
                if firstCharString != sectionTitle {
                    sectionTitle = firstCharString
                    self.filtercontactListGrouped[sectionTitle] = [String]()
                    self.filtersectionTitleList.append(sectionTitle)
                }
                self.filtercontactListGrouped[firstCharString]?.append(currentRecord)
            }
        } else {
            
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
        }
        DispatchQueue.main.async {
            self.tblNewContact.reloadData()

        }
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
            self.splitDataInToSection()
        })
    }
}
