//
//  SettingsPageTableViewController.swift
//  Trendine
//
//  Created by Rockson on 09/01/2017.
//  Copyright © 2017 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData



class SettingsPageTableViewController: UITableViewController {
    
    let reuseIdentifier = "reuseIdentifier"
    var objects = [["Notifications" ,"General", "Account", "Privacy", "About Us"], ["Log out"]]
    
    let moc: NSManagedObjectContext = {
        let objectContext: NSManagedObjectContext?
        let appDel = UIApplication.shared.delegate as! AppDelegate
        objectContext = appDel.persistentContainer.viewContext
        return objectContext!
        
    }()
    
    let blurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.layer.cornerRadius = 8
        bView.clipsToBounds = true
        return bView
        
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        ac.translatesAutoresizingMaskIntoConstraints = false
        ac.hidesWhenStopped = true
        return ac
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            keyWindow.addSubview(blurView)
            
            blurView.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor).isActive = true
            blurView.centerYAnchor.constraint(equalTo: keyWindow.centerYAnchor).isActive = true
            blurView.widthAnchor.constraint(equalToConstant: 120).isActive = true
            blurView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            
            blurView.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            activityIndicator.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
            activityIndicator.widthAnchor.constraint(equalToConstant: 30).isActive = true
            activityIndicator.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            blurView.isHidden = true
            
        }

      navigationItem.title = "Settings"
        tableView.register(SettingsPageTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)

     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            
            return 5
            
        }else{
            
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsPageTableViewCell
        
       let title = self.objects[indexPath.section][indexPath.row]
       cell.textLabel?.text = title
        
        if title == "Log out" {
            
            cell.textLabel?.textColor = .red
            
        }else{
            
            cell.textLabel?.textColor = .black
  
            
        }
        
        if title != "Log out" {
            
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            
            
            
        }
        
        return cell
    }
 

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTitle = self.objects[indexPath.section][indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
//        let cell = tableView.cellForRow(at: indexPath) as! SettingsTableViewCell
        
        if selectedTitle == "Notifications" {
          
            let notificationVC = NotificationSettingsTableViewController(style: UITableViewStyle.grouped)
            notificationVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(notificationVC, animated: true)
            
        }
        
        if selectedTitle == "Privacy" {
            
            let privacyDetailsVC = PrivacyDetailsTableViewController(style: UITableViewStyle.grouped)
            privacyDetailsVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(privacyDetailsVC, animated: true)
        }
        
        if selectedTitle == "About Us" {
            
            let aboutUsVC = AboutUsViewController()
            aboutUsVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(aboutUsVC, animated: true)
            
        }
        
        if selectedTitle == "General" {
            
            let profileVC = GeneralSettingsTableViewController(style: UITableViewStyle.grouped)
            profileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profileVC, animated: true)
            
        }
        
        if selectedTitle == "Account" {
            
            let profileVC = ChangeProfileInfoTableViewController(style: UITableViewStyle.grouped)
            profileVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(profileVC, animated: true)
            
        }
     
        if selectedTitle == "Log out" {
            
            UserDefaults.standard.removeObject(forKey: "numberOfNotifications")
    
            
            let fetch: NSFetchRequest<Contacts> = Contacts.fetchRequest()
            fetch.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            
            do {
                
                let results = try self.moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Contacts]
                
                if results.count > 0 {
                    
                    for result in results{
                        
                        self.moc.delete(result)
                        
                    }
                    
                    do {
                        
                        try self.moc.save()
                        self.finallyLogOut()

                      
                    }catch{}
                    
                    
                }else{
                    
                    //no contacts
                    self.finallyLogOut()
                    
                }
                
            }catch{}
            
            
            
        }
        
        
        
        
    }
 
    
    
    func finallyLogOut(){
        print("checking installation....")
        
        BmobUser.logout()
        
        let loginVC = LoginViewController()
        self.present(loginVC, animated: true, completion: nil)
        
    }
    

}
