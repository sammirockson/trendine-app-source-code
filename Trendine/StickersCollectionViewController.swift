//
//  StickersCollectionViewController.swift
//  Trendine
//
//  Created by Rockson on 09/01/2017.
//  Copyright © 2017 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData

class StickersCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let reuseIdentifier = "Cell"

    var stickers = [BmobObject]()
    
    
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
        bView.isHidden = false
        return bView
        
    }()
    
    let backgroundBlurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.clipsToBounds = true
        bView.isHidden = false
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
        
        if let motherView = self.view {
            
            motherView.addSubview(backgroundBlurView)
            
            
            backgroundBlurView.topAnchor.constraint(equalTo: motherView.topAnchor).isActive = true
            backgroundBlurView.leftAnchor.constraint(equalTo: motherView.leftAnchor).isActive = true
            backgroundBlurView.widthAnchor.constraint(equalTo: motherView.widthAnchor).isActive = true
            backgroundBlurView.heightAnchor.constraint(equalTo: motherView.heightAnchor).isActive = true
            
            backgroundBlurView.addSubview(blurView)
            
            blurView.centerXAnchor.constraint(equalTo: backgroundBlurView.centerXAnchor).isActive = true
            blurView.centerYAnchor.constraint(equalTo: backgroundBlurView.centerYAnchor).isActive = true
            blurView.widthAnchor.constraint(equalToConstant: 150).isActive = true
            blurView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            blurView.addSubview(activityIndicator)
         
            
            activityIndicator.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
            activityIndicator.widthAnchor.constraint(equalToConstant: 25).isActive = true
            activityIndicator.heightAnchor.constraint(equalToConstant: 25).isActive = true
            
            self.backgroundBlurView.isHidden = true
            
        }

       navigationItem.title = "Stickers"

        self.collectionView!.register(StickersCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
        
        
        self.loadStickers()
        
        self.showAlert(reason: "Tap to preview sticker or save sticker")


    }
    
    
    func showAlert(reason: String){
        
        
        let alert = UIAlertController(title: "Download Stickers", message: reason, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
//    func handleSaveFinished(){
//        
//        self.backgroundBlurView.isHidden = true
// 
//        
//    }
    
    func loadStickers(){

        let query = BmobQuery(className: "Stickers")
        query?.order(byDescending: "createdAt")
        query?.cachePolicy = kBmobCachePolicyCacheThenNetwork
        query?.findObjectsInBackground({ (results, error) in
            if error == nil {
                
                if (results?.count)! > 0 {
                    
                    self.stickers.removeAll(keepingCapacity: true)
                    
                    for result in results! {
                        
                        if let object = result as? BmobObject {
                            
                            self.stickers.append(object)
                            
                        }
                        
                    }
                    
                    DispatchQueue.main.async {
                        
                        self.collectionView?.reloadData()
                        
                        
                    }
                    
                    
                }else{
                
                
                   
                    
                }
                
            }
        })
        
        
        
        
    }

  
    func handleRightButtonTapped(){
        
        print("button works...")
//        
//        let alert = UIAlertController(title: "", message: "Select three (3) photos", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (action) in
        
//            let layout = UICollectionViewFlowLayout()
//            let photosVC = PickPhotosCollectionViewController(collectionViewLayout: layout)
//            photosVC.incomingViewController = self
//            let photosNV = UINavigationController(rootViewController: photosVC)
//            self.present(photosNV, animated: true, completion: nil)
            
//        }))
//        
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func handleAnimateImages(gesture: UITapGestureRecognizer){
        
        
        
        if let imageView = gesture.view as? UIImageView {
           let point = imageView.convert(imageView.bounds.origin, to: self.collectionView)
            if let indexPath = self.collectionView?.indexPathForItem(at: point){
                
                let object = self.stickers[indexPath.item]
                self.handleSaveStickerButtonTapped(indexP: indexPath as NSIndexPath)
                
                if let imageFile1 = object.object(forKey: "gif") as? BmobFile {
                
                    let image = UIImage.gifImageWithURL(gifUrl: imageFile1.url)
                    imageView.image = image
                                
                                
                }
           
              

                
            }
            
            
        }
        
        
        
    }
    
    
    
    func handleSaveStickerButtonTapped(indexP: NSIndexPath){
        
        let alert = UIAlertController(title: "Save sticker", message: "Sticker will be accessible in your messages", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            
            self.backgroundBlurView.isHidden = false
            self.activityIndicator.startAnimating()

            
            var stickerHeight: Float = 0
            var stickerWidth: Float = 0
            
            //let point = sender.convert(sender.bounds.origin, to: self.collectionView)
           // if let indexPath = self.collectionView?.indexPathForItem(at: point){
                
                let object = self.stickers[indexP.item]
                
                
                if let previewFile = object.object(forKey: "preview") as? BmobFile {
                    print("its available....")
                    
                    
                    if let stickerFile = object.object(forKey: "gif") as? BmobFile {
                        print("its available too....")
                        
                        
                        let entity = NSEntityDescription.insertNewObject(forEntityName: "Stickers", into: self.moc) as! Stickers
                        
                        if let stickerPreview = NSData(contentsOf: NSURL(string: previewFile.url) as! URL){
                            
                            if let stickerData = NSData(contentsOf: NSURL(string: stickerFile.url) as! URL){
                                
                                if let height = object.object(forKey: "height") as? Int {
                                    
                                    stickerHeight = Float(height)
                                }
                                
                                
                                if let width = object.object(forKey: "width") as? Int {
                                    
                                    stickerWidth = Float(width)
                                }
                                
                                
                                
                                print("its available....")
                                
                                entity.createdAt = NSDate()
                                entity.previewData = stickerPreview
                                entity.stickerData = stickerData
                                entity.stickerHeight = stickerHeight
                                entity.stickerWidth = stickerWidth
                                entity.stickerId = object.objectId
                                
                                do {
                                    
                                    try self.moc.save()
                                    print("successfully saved to coreData permanently")
                                    
                                    self.backgroundBlurView.isHidden = true
                                    self.activityIndicator.stopAnimating()

                                    
                                }catch {
                                    
                                    self.backgroundBlurView.isHidden = true
                                    self.activityIndicator.stopAnimating()


                                    fatalError("error \(error)")
                                }
                                
                                
                            }
                            
                            
                        }
                        
                       
                        
                    }
                    
                //}
                
                
                
                
                
            }
            
            
        }))
        self.present(alert, animated: true, completion: nil)
        
       
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.stickers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! StickersCollectionViewCell
        cell.saveStickerButton.addTarget(self, action: #selector(handleSaveStickerButtonTapped), for: .touchUpInside)
        
        let object = self.stickers[indexPath.item]
        
        if let previewFile = object.object(forKey: "preview") as? BmobFile {
            
            cell.displayImageView.sd_setImage(with: NSURL(string: previewFile.url) as! URL, placeholderImage: UIImage(named: "personplaceholder"))
        }
        

        cell.displayImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAnimateImages)))
        cell.displayImageView.isUserInteractionEnabled = true
            

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthAndHeight = self.view.frame.width / 2 - 1
        return CGSize(width: widthAndHeight, height: widthAndHeight)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
