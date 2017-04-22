//
//  CountryList.swift
//  Chat_App
//
//  Created by devloper65 on 4/19/17.
//  Copyright © 2017 LaNet. All rights reserved.
//

import UIKit

class CountryList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var tblCountry: UITableView!
    fileprivate var countries: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        
        countries = Countries.getCountriesWithPhone()
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Your Country"
        tblCountry.delegate = self
        tblCountry.dataSource = self
        //Register
        self.tblCountry.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell:CountryCell = tblCountry.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        
        // Configure the cell...
        let country = countries[indexPath.row]
        cell.lblCountryName!.text = country.name
        cell.lblCountryCode!.text = "+\(country.phoneExtension!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:CountryCell = tblCountry.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        cell.imgRight.isHidden = false
        let country = countries[indexPath.row]
        cell.lblCountryName!.text = country.name
        cell.lblCountryCode!.text = "+\(country.phoneExtension!)"

        Register.cName = country.name
        Register.cCode = country.phoneExtension!
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
