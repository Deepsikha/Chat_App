//
//  NewChatVC.swift
//  Chat_App
//
//  Created by devloper65 on 4/20/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit
import AddressBook

class NewChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblNewContact: UITableView!
    @IBOutlet var searchContact: UISearchBar!
    @IBOutlet var vwHeader: UIView!
    @IBOutlet var btnCancel: UIBarButtonItem!
    @IBOutlet var tblHeader: UITableView!
    
    var contactList: [String] = Array()
    var contactListGrouped = NSDictionary() as! [String : [String]]
    var sectionTitleList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblNewContact.delegate = self
        tblNewContact.dataSource = self
        tblHeader.delegate = self
        tblHeader.dataSource = self
        
        self.title = "New Chat"
        self.navigationController?.isNavigationBarHidden = true
        
        self.tblNewContact.register(UINib(nibName: "NewChatCell", bundle: nil), forCellReuseIdentifier: "NewChatCell")
        self.tblHeader.register(UINib(nibName: "NewChatHeaderCell", bundle: nil), forCellReuseIdentifier: "NewChatHeaderCell")
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
        self.createData()
        self.splitDataInToSection()
    }
    
    // MARK: - Delegate Method
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblHeader {
            return 1
        } else {
            return self.contactListGrouped.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblHeader {
            return 2
        } else {
            let sectionTitle = self.sectionTitleList[section]
            let contacts = self.contactListGrouped[sectionTitle]
            return contacts!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        
        let sectionTitle = self.sectionTitleList[(indexPath as NSIndexPath).section]
        let contacts = self.contactListGrouped[sectionTitle]
        cell.lblContact?.text = contacts![(indexPath as NSIndexPath).row]
        cell.lblStatus.text = ""
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == tblNewContact {
            return self.sectionTitleList[section]
        } else {
            return nil
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if tableView == tblNewContact {
            return self.sectionTitleList
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
    
    //MARK:- Outlet Method
    @IBAction func handleBtncancel(_ sender: Any) {
    }
    
    // MARK: - Custom Method
    
    func tapHandler() {
        self.searchContact.resignFirstResponder()
    }
    
    fileprivate func createData() {
        
        // fill up data
        self.contactList  = [
            "Mike",
            "Jaddu", "Master", "Keka",
            "Volter", "Val",
            "Rick", "Mcley",
            "Domino's", "McDownalds",
            "Suger&Spice",
            "PizzHut", "Fendi", "Virat",
            "Smith",
            "Dhoni", "Finch", "Morgan", "Lynn",
            "Maxy",
            "Chiku",
            "Nthg", "Anonymous", "Mine", "Unknown",
            "Raspberry",
            "Arduino"
        ]
        
        // sort the array  (Important)
        self.contactList = self.contactList.sorted()
    }

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
    }
}
