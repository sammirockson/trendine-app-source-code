//
//  GeneralSettingsTableViewController.swift
//  Trendin
//
//  Created by Rockson on 06/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData

class GeneralSettingsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let reuseIdentifier = "reuseIdentifier"
    
    
    
    let iconTitles = [["Default Background" , "Chat Background"], ["Clear Chat History"]]

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "General"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        tableView.register(GeneralSettingsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            
            var pickedImage: UIImage?
            
            if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                
               pickedImage = image
            }
            
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
               
                pickedImage = image

            }
            
            if let image = pickedImage {
                
                let imageData = UIImageJPEGRepresentation(image, 1.0)
                UserDefaults.standard.setValue(imageData, forKey: "chatBackgroundImage")
                self.displayAlert(reason: "Success")
            }
        
        
          
//        self.dismiss(animated: true, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
   
    
            self.dismiss(animated: true, completion: nil)
            
            
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            
            return 2
            
            
        }else{
            
            return 1
   
            
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! GeneralSettingsTableViewCell
        
        let text = self.iconTitles[indexPath.section][indexPath.row]
        cell.textLabel?.text = text
        
        if text == "Clear Chat History" {
            
            cell.textLabel?.textColor = .red
            
            
        }else{
            
            cell.textLabel?.textColor = .black
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

  
        }

        // Configure the cell...

        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTitle = self.iconTitles[indexPath.section][indexPath.row]
        
        if selectedTitle == "Chat Background"{
           
            let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        
        if selectedTitle == "Default Background"{
            
            if let image = UIImage(named: "giftly") {
                
                let imageData = UIImageJPEGRepresentation(image, 1.0)
                UserDefaults.standard.setValue(imageData, forKey: "chatBackgroundImage")
                
                self.displayAlert(reason: "Success")
                
            }
        }
        
        
        if selectedTitle == "Clear Chat History"{
            
            //Freeze the App interaction until the operation is complete
            
            
            let alert = UIAlertController(title: "", message: "Do you want to clear all chat history?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { (action) in
              
                let AppDel = UIApplication.shared.delegate as! AppDelegate
                let moc = AppDel.persistentContainer.viewContext
                
                let fetch: NSFetchRequest<Messages> = Messages.fetchRequest()
                fetch.sortDescriptors = [ NSSortDescriptor(key: "createdAt", ascending: false)]
                
                
                do {
                    
                    let results = try moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Messages]
                    
                    if results.count > 0 {
                        
                        for result in results {
                            
                            moc.delete(result)
                        }
                        
                        
                        do {
                            
                            try moc.save()
                            
                        }catch{
                            
                            print(error)
                        }
                        
                        
                    }
                    
                }catch{
                    
                    print(error)
                }
                
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
          
 
            
        }
    }
    
    
    func displayAlert(reason: String){
        
      let alert = UIAlertController(title: "", message: reason, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }

   

}
