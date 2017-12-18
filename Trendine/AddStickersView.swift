//
//  AddStickersView.swift
//  Trendine
//
//  Created by Rockson on 09/01/2017.
//  Copyright © 2017 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData

class AddStickersView: UIView , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let identifier = "identifier"
    
    
    let moc: NSManagedObjectContext = {
        let objectContext: NSManagedObjectContext?
        let appDel = UIApplication.shared.delegate as! AppDelegate
        objectContext = appDel.persistentContainer.viewContext
        return objectContext!
        
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let rect = CGRect(x: 0, y: 0, width: 0, height: 0)
        let cl = UICollectionView(frame: rect, collectionViewLayout: layout)
        cl.backgroundColor = UIColor(white: 0.9, alpha: 1)
        cl.delegate = self
        cl.dataSource = self
        cl.translatesAutoresizingMaskIntoConstraints = false
        return cl
        
    }()
    
    
    let displayLabel: UILabel = {
       let label = UILabel()
        label.text = "No stickers"
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isHidden = true
        return label
        
    }()
    
    
    lazy var addStickerButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(#imageLiteral(resourceName: "AddIcon"), for: .normal)
        button.addTarget(self, action: #selector(handleImportStickersButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var stickers = [Stickers]()
    
    var incomingVC: MessagesCollectionViewController?
    
    
//    var stickers = [BmobObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.laodStickersFromCoreData()
        
        self.backgroundColor = .white
        
        self.setUpViews()
        collectionView.register(AddStickersCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
    }
    
    
    func setUpViews(){
        
        addSubview(collectionView)
        addSubview(displayLabel)
        addSubview(addStickerButton)
        
        addStickerButton.bottomAnchor.constraint(equalTo: displayLabel.topAnchor, constant: -4).isActive = true
        addStickerButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        addStickerButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addStickerButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        displayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        displayLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        displayLabel.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        displayLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleImportStickersButtonTapped(){
        
        let layout = UICollectionViewFlowLayout()
       let stickerVC = StickersCollectionViewController(collectionViewLayout: layout)
       self.incomingVC?.navigationController?.pushViewController(stickerVC, animated: true)
        
    }
    

    func laodStickersFromCoreData(){
        
        
            let fetch: NSFetchRequest<Stickers> = Stickers.fetchRequest()
            fetch.sortDescriptors = [ NSSortDescriptor(key: "createdAt", ascending: false)]
            fetch.fetchLimit = 40
            
            do {
                
                let results = try moc.fetch(fetch as! NSFetchRequest<NSFetchRequestResult>) as! [Stickers]
                
                if results.count > 0 {
                    
                    self.addStickerButton.isHidden = true
                    
                    for result in results {
                        
                        
                        self.stickers.append(result)
                            
                     
                    }
                    
                    
                    DispatchQueue.main.async {
                      
                        self.collectionView.reloadData()
                    }
                    
                }else{
                    
                    
                    self.addStickerButton.isHidden = false
                    self.displayLabel.isHidden = false
                    
                }
                
            }catch{
                
                self.displayLabel.isHidden = false

                print(error.localizedDescription)
            }
        
  
        
        
        
    }
    
    func handleAnimateImages(gesture: UITapGestureRecognizer){
    
        if let imageView = gesture.view as? UIImageView {
            let point = imageView.convert(imageView.bounds.origin, to: self.collectionView)
            if let indexPath = self.collectionView.indexPathForItem(at: point){
                
                let selectedObject = self.stickers[indexPath.item]
                
                if let messagesVC = self.incomingVC {
               
                    
                    if let data = selectedObject.stickerData{
                        
                        let width = CGFloat(selectedObject.stickerWidth)
                        let height = CGFloat(selectedObject.stickerHeight)

                        let size = CGSize(width: width, height: height)
                        messagesVC.sendSticker(stickerData: data, size: size)
                        
                    }
                    

                    
                }
            
                
            }
            
            
        }
        
        
        
    }
    
    var removeId = ""
    func handleDeleteSticker(gesture: UILongPressGestureRecognizer){
        
        removeId = ""

        
        if let sender = gesture.view{
            
            if gesture.state == .began{
                
               let alert = UIAlertController(title: "Delete sticker?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
                    
                    let point = sender.convert(sender.bounds.origin, to: self.collectionView)
                    if let indexPath = self.collectionView.indexPathForItem(at: point){
                        
                        let selectedObject = self.stickers[indexPath.item]
                        
                        self.removeId = selectedObject.stickerId!
                        
                        self.stickers.remove(at: indexPath.item)
                        self.collectionView.reloadData()

                        
                        let request: NSFetchRequest<Stickers> = Stickers.fetchRequest()
                        request.predicate = NSPredicate(format: "stickerId == %@", (self.removeId))
                        
                        do {
                            let searchResults = try self.moc.fetch(request)
                            
                            if searchResults.count > 0 {
                                
                                for message in searchResults {
                                    
                                    self.moc.delete(message)
                                    
                                    
                                }
                                
                                
                            
                                
                                do {
                                    
                                    try self.moc.save()
                                    
                                    self.displayLabel.isHidden = false
                                    
                                }catch{
                                    
                                    print(error.localizedDescription as Any)
                                    
                                }
                                
                                
                            }
                            
                            
                        } catch {
                            print("Error with request: \(error)")
                        }
                       
                    
                    }
                    
                    
                }))
                
              incomingVC?.present(alert, animated: true, completion: nil)
                
                
            }
            
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return self.stickers.count
    }

  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! AddStickersCollectionViewCell
        
        cell.displayImageView.layer.cornerRadius = 4
        cell.displayImageView.clipsToBounds = true
        
           let stickerData = self.stickers[indexPath.item]
        
        
        cell.displayImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleAnimateImages)))
        cell.displayImageView.isUserInteractionEnabled = true
        cell.displayImageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleDeleteSticker)))

        
        if let previewImageData = stickerData.previewData {
            
            cell.displayImageView.image = UIImage(data: previewImageData as Data)
        
            
        }
        
      
        
        
     return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let heightAndWidth: CGFloat = 90
        
        return CGSize(width: heightAndWidth, height: heightAndWidth)
    }
    
    
}
