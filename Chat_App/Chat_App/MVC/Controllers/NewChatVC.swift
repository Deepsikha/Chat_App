//
//  NewChatVC.swift
//  Chat_App
//
//  Created by devloper65 on 4/20/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import Contacts
import SDWebImage
class NewChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, SDWebImageManagerDelegate {
    
    @IBOutlet var tblNewContact: UITableView!
    @IBOutlet var searchContact: UISearchBar!
    @IBOutlet var vwHeader: UIView!
    @IBOutlet var tblHeader: UITableView!
    
    var caller: String = "ChatListController"
    let store = CNContactStore()
    var contactList: NSArray!
    var contactListGrouped = NSDictionary() as! [String : NSArray]
    var sectionTitleList = [String]()
    var filteredContactList: NSArray!
    var filtercontactListGrouped = NSDictionary() as! [String : NSArray]
    var filtersectionTitleList = [String]()
    var isSearch:Bool = false

    var tap:UITapGestureRecognizer!
    
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
        
        self.tblNewContact.register(UINib(nibName: "NewChatCell", bundle: nil), forCellReuseIdentifier: "NewChatCell")
        self.tblHeader.register(UINib(nibName: "NewChatHeaderCell", bundle: nil), forCellReuseIdentifier: "NewChatHeaderCell")
        self.tblNewContact.register(UINib(nibName: "CallCell", bundle: nil), forCellReuseIdentifier: "CallCell")
        //taphandle
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    
        self.tblNewContact.tableHeaderView = self.vwHeader
        self.searchContact.placeholder = "Search"
        
    }
    
    override func viewDidLayoutSubviews() {
        print("")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleBtncancel(_:)))
       self.contactList = NSArray(array: ModelManager.getInstance().getAllData("user"))
       self.contactList = self.contactList.sorted(by: { (a, b) -> Bool in
            return ((a as! NSDictionary)["username"]! as! String) < ((b as! NSDictionary)["username"]! as! String)
       }) as NSArray
        splitDataInToSection()
        print(contactList!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tblNewContact.register(UINib(nibName: "NewChatCell", bundle: nil), forCellReuseIdentifier: "NewChatCell")
        self.tblHeader.register(UINib(nibName: "NewChatHeaderCell", bundle: nil), forCellReuseIdentifier: "NewChatHeaderCell")
        self.tblNewContact.register(UINib(nibName: "CallCell", bundle: nil), forCellReuseIdentifier: "CallCell")
    }
    
    // MARK: - Table Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int {
        if !(self.caller.isEmpty) {
            if self.caller == "ChatListController" {
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
                    cell.lblContact?.text = (contacts?.object(at: 0) as AnyObject).value(forKey: "username")! as? String
                    cell.lblStatus.text = (contacts?.object(at: 0) as AnyObject).value(forKey: "status_user")! as? String
                    cell.imgContact.sd_setImage(with: URL(string: ((contacts?.object(at: 0) as AnyObject).value(forKey: "profile_thumb")! as? String)! ), placeholderImage: UIImage(named: "default-user"), options: .progressiveDownload, completed: { (image, error, memory, imageUrl) in
                        
                    })
                    cell.imageURL = URL(string:((contacts?.object(at: 0) as AnyObject).value(forKey: "profile_thumb")! as? String)!)
                    cell.parent = self
                } else {
                    let sectionTitle = self.sectionTitleList[(indexPath as NSIndexPath).section]
                    let contacts = self.contactListGrouped[sectionTitle]
                    cell.lblContact?.text = (contacts?.object(at: 0) as AnyObject).value(forKey: "username")! as? String
                    cell.lblStatus.text = (contacts?.object(at: 0) as AnyObject).value(forKey: "status_user")! as? String
                    var url = ((contacts?.object(at: 0) as AnyObject).value(forKey: "profile_thumb")! as? String)!
                    let fileURL = URL(string: url)
                    cell.imgContact.sd_setImage(with: fileURL, placeholderImage: UIImage(named: "default-user"), options: .progressiveDownload, completed: { (image, error, memory, imageUrl) in
                        
                    })
                    cell.imageURL = URL(string:((contacts?.object(at: 0) as AnyObject).value(forKey: "profile_thumb")! as? String)!)
                    cell.parent = self
                }
                
                return cell
            }
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CallCell", for: indexPath) as! CallCell
            self.tblNewContact.tableHeaderView = nil
            let sectionTitle = self.sectionTitleList[(indexPath as NSIndexPath).section]
            let contacts = self.contactListGrouped[sectionTitle]
            cell.lblCallPerson?.text = (contacts?.object(at: 0) as AnyObject).value(forKey: "username")! as? String
            
            cell.lblLastCallStatus.text = ""
            cell.imgCall.sd_setImage(with: URL(string: ((contacts?.object(at: 0) as AnyObject).value(forKey: "profile_thumb")! as? String)! ), placeholderImage: UIImage(named: "default-user"), options: SDWebImageOptions.progressiveDownload, completed: { (image, error, memory, imageUrl) in
                
            })
            
            cell.imgCalltype.image = UIImage(named: "incomingcall")
            cell.imgCalltype.image = cell.imgCalltype.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            cell.imgCalltype.tintColor = UIColor.green
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionTitle = self.sectionTitleList[(indexPath as NSIndexPath).section]
        let contacts = self.contactListGrouped[sectionTitle]
        ChatController.reciever_id = (contacts?.object(at: 0) as AnyObject).value(forKey: "user_id")! as? Int
        ChatController.recname = (contacts?.object(at: 0) as AnyObject).value(forKey: "username")! as? String
        ChatController.type = "single"
        self.navigationController?.pushViewController(ChatController(), animated: true)
        
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
        filteredContactList = NSArray()
        
//        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", self.searchContact.text!)
//        let array = contactList.filtered(using: searchPredicate)
//        filteredContactList = array as NSArray
        
        filteredContactList = contactList.filter({ (a) -> Bool in
            ((a as! NSDictionary)["username"]! as! String).lowercased().contains((self.searchContact.text!).lowercased())
        }) as NSArray

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
                
                let currentRecord = self.filteredContactList.object(at: i)
                let firstChar = ((currentRecord as AnyObject).value(forKey: "username")! as! String).characters.first
                let firstCharString = "\(String(describing: firstChar!))"
                if firstCharString != sectionTitle {
                    sectionTitle = firstCharString
                    self.filtercontactListGrouped[sectionTitle] = NSArray()
                    self.filtersectionTitleList.append(sectionTitle)
                }
                self.filtercontactListGrouped[firstCharString] = self.filtercontactListGrouped[firstCharString]?.adding(currentRecord) as NSArray?
            }
        } else {
            
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
        }
        DispatchQueue.main.async {
            self.tblNewContact.reloadData()

        }
    }
    
    func taphandler()
    {
        self.view.subviews.last?.removeFromSuperview()
        self.view.removeGestureRecognizer(tap)
    }

    
    
}
