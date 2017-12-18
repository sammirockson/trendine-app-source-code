//
//  NameCardTableViewController.swift
//  Trendin
//
//  Created by Rockson on 29/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData

class NameCardTableViewController: UITableViewController, UISearchResultsUpdating {
    
    private let reuseIdentifier = "reuseIdentifier"
    var incomingViewController: MessagesCollectionViewController?
    
    var friends = [Contacts]()
    
    var searchController = UISearchController()
    var resultsTableViewController = UITableViewController()
    
    
    let moc: NSManagedObjectContext = {
        let objectContext: NSManagedObjectContext?
        let appDel = UIApplication.shared.delegate as! AppDelegate
        objectContext = appDel.persistentContainer.viewContext
        return objectContext!
        
    }()
    
    lazy var fetchedResultsControler: NSFetchedResultsController<NSFetchRequestResult> = {
        
        let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
        request.sortDescriptors =  [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        let fetchResults = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchResults as! NSFetchedResultsController<NSFetchRequestResult>
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(NameCardTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        self.resultsTableViewController.tableView.register(NameCardTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        self.resultsTableViewController.tableView.dataSource = self
        self.resultsTableViewController.tableView.delegate = self
        
        self.searchController = UISearchController(searchResultsController: self.resultsTableViewController)
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = true
        self.tableView.tableHeaderView = self.searchController.searchBar
        definesPresentationContext = true
        
        let lefttBarItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(handleLeftBarButton))
        navigationItem.leftBarButtonItem = lefttBarItem

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        self.loadFriendsFromCoreData()
        
    }
    
    
    func handleLeftBarButton(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadFriendsFromCoreData(){
        
        do {
            
            try self.fetchedResultsControler.performFetch()
            
            if let fetchedContacts = self.fetchedResultsControler.fetchedObjects as? [Contacts] {
                
                if fetchedContacts.count > 0 {
                    
                    self.friends.removeAll(keepingCapacity: true)
                    
                    for contact in fetchedContacts {
                        
                        if contact.objectId != BmobUser.current().objectId {
                            
                            self.friends.append(contact)

                        }
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.tableView.reloadData()
                    }
                    
                    
                }
                
            }
            
            
            
        }catch {
            
            print(error)
        }
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let query = BmobQuery(className: "_User")
        query?.whereKey("username", equalTo: searchController.searchBar.text)
        query?.cachePolicy = kBmobCachePolicyCacheElseNetwork
        query?.findObjectsInBackground({ (results, error) in
            if error == nil {
             
                
            }
        })
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.friends.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NameCardTableViewCell

        let userInfo = self.friends[indexPath.row]
        if let username = userInfo.username {
            
            cell.usernameLabel.text = username
  
        }
        

        if let imageData = userInfo.profileImageData{
            let profileImage = UIImage(data: imageData as Data)
            cell.profileImageView.image = profileImage
        }
        
//        let query = BmobQuery(className: "_User")
//        query?.whereKey("objectId", equalTo: userInfo.objectId)
//        query?.limit = 1
//        query?.cachePolicy = kBmobCachePolicyCacheElseNetwork
//        query?.findObjectsInBackground({ (users, error) in
//            if error == nil {
//                if (users?.count)! > 0 {
//                    
//                    for user in users! {
//                        
//                        if let newUser = user as? BmobUser {
//                            
//                            DispatchQueue.main.async {
//                                
//                                
//                                if let profileImageFile = newUser.object(forKey: "profileImageFile") as? BmobFile {
//                                    
//                                    .sd_setImage(with: NSURL(string: profileImageFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
//                                    
//                                    
//                                }
//                            }
//                            
//                        }
//                        
//                    }
//                    
//                    
//                }
//                
//                
//                
//            }
//        })

        return cell
    }
 
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = self.friends[indexPath.row]
        
        self.dismiss(animated: true, completion: {
        

            self.incomingViewController?.addNameCard(selectedUser: selectedItem)
            
        
        })
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
