//
//  NotificationSettingsTableViewController.swift
//  Trendine
//
//  Created by Rockson on 09/01/2017.
//  Copyright © 2017 RockzAppStudio. All rights reserved.
//

import UIKit
import UserNotifications


class NotificationSettingsTableViewController: UITableViewController, UNUserNotificationCenterDelegate {
    
    let objects = ["Alert Sound" ,"Show In-App Banner"]
    
    let reuseIdentifier = "reuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        
      
      
        
//        UIApplication.shared.unregisterForRemoteNotifications()
        
        navigationItem.title = "Notifications"
        
        tableView.register(NotificationSettingsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

    
    func handleSwitchSwipe(sender: UISwitch){
        
        let center  = UNUserNotificationCenter.current()
        center.delegate = self

        
        let point = sender.convert(sender.bounds.origin, to: tableView)
        
        if let indexPath = tableView.indexPathForRow(at: point), let cell = tableView.cellForRow(at: indexPath) as? NotificationSettingsTableViewCell{
            
            if cell.textLabel?.text == "Alert Sound"{
                
                if sender.isOn == true {
                    
                    center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                        if error == nil{
                            UIApplication.shared.registerForRemoteNotifications()
                            
                            UserDefaults.standard.setValue(true, forKey: "AlertSoundAll")
                        }
                    }
                    
                }else if sender.isOn == false {
                    
                    
                    center.requestAuthorization(options: [.alert, .badge]) { (granted, error) in
                        if error == nil{
                            UIApplication.shared.registerForRemoteNotifications()
                            
                            UserDefaults.standard.setValue(false, forKey: "AlertSoundAll")

                            

                        }
                    }
                    
                }
               
                
                
            }else if cell.textLabel?.text == "Show In-App Banner"{
                
                if sender.isOn == true {
                    
                    center.requestAuthorization(options: [.sound, .alert ,.badge]) { (granted, error) in
                        if error == nil{
                            UIApplication.shared.registerForRemoteNotifications()
                            
                            UserDefaults.standard.setValue(true, forKey: "ShowBannerAll")


                        }
                    }
                    
                }else if sender.isOn == false {
                    
                    
                    center.requestAuthorization(options: [.sound, .badge]) { (granted, error) in
                        if error == nil{
                            UIApplication.shared.registerForRemoteNotifications()
                            
                            
                            UserDefaults.standard.setValue(false, forKey: "ShowBannerAll")


                        }
                    }
                    
                }
                
                
                
            }
            
        }
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.objects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationSettingsTableViewCell
        tableView.allowsSelection = false
        
       let title = self.objects[indexPath.row]
       cell.textLabel?.text = title

        cell.switchButton.addTarget(self, action: #selector(handleSwitchSwipe), for: UIControlEvents.valueChanged)


        if title == "Alert Sound" {
            
            
            if let AlertSound = UserDefaults.standard.object(forKey: "AlertSoundAll") as? Bool {
                
                if AlertSound == true {
                    
                    cell.switchButton.isOn = true
  
                    
                }else{
                    
                    cell.switchButton.isOn = false
  
                    
                }
            }

          
            
        }
        
        
        if title == "Show In-App Banner" {
          
            if let AlertBanner = UserDefaults.standard.object(forKey: "ShowBannerAll") as? Bool {
                
                if AlertBanner == true {
                    
                    cell.switchButton.isOn = true
                    
                    
                }else{
                    
                    cell.switchButton.isOn = false
                    
                    
                }
            }
        
            
        }
        
       

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
  

}
