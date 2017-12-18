//
//  AttachmentItemsView.swift
//  Trendine
//
//  Created by Rockson on 06/05/2017.
//  Copyright © 2017 RockzAppStudio. All rights reserved.
//

import UIKit

struct AttachmentItems {
    var iconImage: UIImage
}

class AttachmentItemsView: UIView , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var incomingVC: ChatLogCollectionViewController?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        //       layout.scrollDirection = .horizontal
        let collectView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectView.translatesAutoresizingMaskIntoConstraints = false
        collectView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        
        return collectView
    }()
    
    
    var items: [AttachmentItems] = {
        let images = [AttachmentItems]()
        let camera = AttachmentItems(iconImage: #imageLiteral(resourceName: "Camera"))
        let imagePicker = AttachmentItems(iconImage: #imageLiteral(resourceName: "imagePicker"))
        return  [camera, imagePicker]
        
    }()
    
    private let reuseIdentifier = "reuseIdentifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(white: 0.8, alpha: 0.9).cgColor
        
        setUpViews()
        
        collectionView.register(AttachmetItemsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews(){
        
        self.addSubview(collectionView)
        
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 8).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        
    }
    
    
    func handleImageTapped(gesture: UITapGestureRecognizer){
        
        if let sender = gesture.view as? UIImageView {
            if sender.image == #imageLiteral(resourceName: "imagePicker") {
                
                let picker = UIImagePickerController()
                picker.delegate = incomingVC
                picker.sourceType = .photoLibrary
                incomingVC?.present(picker, animated: true, completion: nil)
                
            }
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as!AttachmetItemsCollectionViewCell
        
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        
        let item = items[indexPath.item]
        cell.imageView.image = item.iconImage
        cell.imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTapped)))
        cell.imageView.isUserInteractionEnabled = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.frame.width / 5), height: (self.frame.width / 5))
    }
    
}
