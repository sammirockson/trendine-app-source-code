//
//  PrivacyDetailsTableViewController.swift
//  Trendin
//
//  Created by Rockson on 08/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class PrivacyDetailsTableViewController: UITableViewController {
    
    let reuseIdentifier = "reuseIdentifier"
    
    var titles = [["Find Me By Phone Number", "Find Me By People NearBy"], ["Blocked"], ["Privacy Policy"]]

    override func viewDidLoad() {
        super.viewDidLoad()

       navigationItem.title = "Privacy"
        
        tableView.register(PrivacyDetailsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwitchSwipe(sender: UISwitch){
        
        let point = sender.convert(sender.bounds.origin, to: tableView)
        
        if let indexPath = tableView.indexPathForRow(at: point), let cell = tableView.cellForRow(at: indexPath) as? PrivacyDetailsTableViewCell{
            
           if cell.textLabel?.text == "Find Me By Phone Number"{
            
            self.updateUserSettings(findBy: "FindByPhone", status: sender.isOn)
            print(sender.isOn)
            }else if cell.textLabel?.text == "Find Me By People NearBy"{
            
            self.updateUserSettings(findBy: "FindByNearBy", status: sender.isOn)
            
            }
            
        }
        
    }
    
    func updateUserSettings(findBy: String, status: Bool){
        
        let currentUser = BmobUser.current()
        currentUser?.setObject(status, forKey: findBy)
        currentUser?.updateInBackground(resultBlock: { (success, error) in
            if success{
                
                print("updated...")
                
            }else{
                
                
                print(error?.localizedDescription as Any)
            }
        })
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            
            return 2
            
        }else if section == 1 {
            
            return 1
            
        }else{
            
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PrivacyDetailsTableViewCell
        
        let selectedTitle  = self.titles[indexPath.section][indexPath.row]
        cell.textLabel?.text = selectedTitle
        
        if selectedTitle == "Find Me By Phone Number"{
            
            if let FindByPhone = BmobUser.current().object(forKey: "FindByPhone") as? Bool {
                
                if FindByPhone == true {
                    
                    cell.findMeByPhoneNumberSwitch.isOn = true
                    
                }else{
                    
                    cell.findMeByPhoneNumberSwitch.isOn = false
                    
                }
            }
        }
        
        if selectedTitle == "Find Me By People NearBy"{
            
            if let FindByNearBy = BmobUser.current().object(forKey: "FindByNearBy") as? Bool {
                
                if FindByNearBy == true {
                    
                    cell.findMeByPhoneNumberSwitch.isOn = true
                    
                }else{
                    
                    cell.findMeByPhoneNumberSwitch.isOn = false
                    
                }
            }
            
        }
        
       
        
        if selectedTitle == "Blocked"{
            
         cell.findMeByPhoneNumberSwitch.isHidden = true
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
    

        }
        
        if selectedTitle == "Privacy Policy"{
            
          
            cell.findMeByPhoneNumberSwitch.isHidden = true
            
            
        }

        
        cell.findMeByPhoneNumberSwitch.addTarget(self, action: #selector(handleSwitchSwipe), for: UIControlEvents.valueChanged)

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedTitle =  self.titles[indexPath.section][indexPath.row]
        
        if selectedTitle == "Blocked"{
            
            let popToBlockedUserVC = BlockedListTableViewController()
            self.navigationController?.pushViewController(popToBlockedUserVC, animated: true)
        }
        
        if selectedTitle == "Privacy Policy" {
            
            let termsAndPrivacyVC = TermsAndPrivacyViewController()
            termsAndPrivacyVC.isIncomingVCTerms = false
            self.navigationController?.pushViewController(termsAndPrivacyVC, animated: true)
        }
       
    }

  

}
