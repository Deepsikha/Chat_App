//
//  SettingsController.swift
//  Chat_App
//
//  Created by Developer88 on 4/17/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class SettingsController: UIViewController , UITableViewDelegate , UITableViewDataSource{

    @IBOutlet var tblvw: UITableView!
    let list = [[""], ["Starred Messages","Web:Desktop"], ["Account","Chat","Notifications","Data and Storage Usage"],["Help","Tell a Friend"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblvw.delegate = self
        tblvw.dataSource = self
        tblvw.register(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "SettingsCell")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            return 70
        } else {
            return 48
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblvw.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        print(indexPath.row)
        let titles = list[indexPath.section][indexPath.row]
        cell.arrimg.image = UIImage(named: "arrright")
        cell.listlbl.text = titles
        cell.imgvw.image = UIImage(named: "\(list[indexPath.section][indexPath.row])")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 4
        case 3:
            return 2
        default:
            return 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    

}
