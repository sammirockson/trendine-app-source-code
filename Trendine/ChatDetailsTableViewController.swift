//
//  ChatDetailsTableViewController.swift
//  Trendin
//
//  Created by Rockson on 08/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData

class ChatDetailsTableViewController: UITableViewController {
    
    let moc: NSManagedObjectContext = {
        let objectContext: NSManagedObjectContext?
        let appDel = UIApplication.shared.delegate as! AppDelegate
        objectContext = appDel.persistentContainer.viewContext
        return objectContext!
        
    }()
    
  
    
    var incomingUser: Contacts?
    let currentUser = BmobUser.current()

    
    let titles = ["Chat Files", "Clear Chat History"]
    
    private let reuseIdentifier = "reuseIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        
       navigationItem.title = "Chat Details"
       tableView.register(ChatDetailsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
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
        return self.titles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ChatDetailsTableViewCell
        
       let title = self.titles[indexPath.row]
        
        cell.textLabel?.text = title
        
        cell.accessoryType = .disclosureIndicator

    
        // Configure the cell...

        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let selectedTitle = self.titles[indexPath.row]

        
        if selectedTitle == "Clear Chat History" {
            
        let alert = UIAlertController(title: "", message: "Do you want to clear chat history?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { (action) in
            
            let request: NSFetchRequest<Messages> = Messages.fetchRequest()
            request.predicate = NSPredicate(format: "roomId == %@", (self.incomingUser?.roomId)!)
            
            do {
                let searchResults = try self.moc.fetch(request)
                
                if searchResults.count > 0 {
                    
                    for message in searchResults {
                        
                        self.moc.delete(message)
                        
                        
                    }
                    
                    do {
                        
                        try self.moc.save()
                        
                    }catch{
                        
                        print(error.localizedDescription as Any)
                        
                    }
                    
                    
                }
                
                
            } catch {
                print("Error with request: \(error)")
            }
            
        }))
            
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
           
            
        }
        
       
        
        if selectedTitle == "Chat Files"{
            
            if let user = self.incomingUser {
                
                let layout = UICollectionViewFlowLayout()
                let chatFilesVC = ChatFilesCollectionViewController(collectionViewLayout: layout)
                chatFilesVC.incomingUser = user
                self.navigationController?.pushViewController(chatFilesVC, animated: true)
                
            }
        
         
            
        }
        
            
        
    }

    

    

  

}
