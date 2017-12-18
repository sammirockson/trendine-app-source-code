//
//  ChangeProfileInfoTableViewController.swift
//  Trendin
//
//  Created by Rockson on 06/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class ChangeProfileInfoTableViewController: UITableViewController {
    
    
    let iconTitles = ["Change Display Name", "Change Profile Picture", "Change Password"]
    
    
    private let reuseIdentifier = "reuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()

       
        navigationItem.title = "Account"
        self.tableView.register(ChangeProfileInfoTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.iconTitles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ChangeProfileInfoTableViewCell
        
        cell.settingsLabel.text = self.iconTitles[indexPath.row]
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator



        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTitle = self.iconTitles[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)

        
        if selectedTitle == "Change Display Name"{
            
            let alert = UIAlertController(title: "Enter New Name", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action) in
                
                if let newName = alert.textFields?.first as UITextField? {
                    
                    let user = BmobUser.current()
                    user?.username = newName.text
                    user?.updateInBackground(resultBlock: { (success, error) in
                        if success{
                            
                            print("user updated successfully")
                            
                           self.displayAlert(reason: "Username Changed!")
                            
                        }else{
                            
                            self.displayAlert(reason: (error?.localizedDescription)!)
                        }
                    })
                   
                }
                
                
                
            }))
            alert.addTextField { (textField) in
                
                textField.placeholder = "New Display Name"
                
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        if selectedTitle == "Change Profile Picture"{
            
            let updateProfilePicVC = UpdateUserInfoViewController()
            self.navigationController?.pushViewController(updateProfilePicVC, animated: true)
        }
        
        if selectedTitle == "Change Password"{
         
            let alert = UIAlertController(title: "Enter your current Password", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (action) in
                
                if let oldPasswordTextField = alert.textFields?.first as UITextField?, let newPasswordTextField = alert.textFields?[1] as UITextField? {
                    
                    let user = BmobUser.current()
                    user?.updateCurrentUserPassword(withOldPassword: oldPasswordTextField.text, newPassword: newPasswordTextField.text, block: { (success, error) in
                        if success{
                            
                          print("password changed")
                            
                          
                            self.displayAlert(reason: "Password Changed!")
                            
                            
                        }else{
                        
                            
                            self.displayAlert(reason: (error?.localizedDescription)!)
                            
                        }
                    })
                }
                
               
                
            }))
            alert.addTextField { (textField) in
                
                textField.placeholder = "Current Password"
                
            }
            alert.addTextField { (textField) in
                
                textField.placeholder = "New Password"
                
            }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        

    }
    

    func displayAlert(reason: String){
        
        let successAlert = UIAlertController(title: reason, message: "", preferredStyle: .alert)
        successAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(successAlert, animated: true, completion: nil)
    }
   
    

}
