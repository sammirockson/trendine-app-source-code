//
//  ChatCollectionViewController.swift
//  Trendine
//
//  Created by Rockson on 06/05/2017.
//  Copyright © 2017 RockzAppStudio. All rights reserved.
//

import UIKit


class ChatCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let reuseIdentifier = "Cell"
    
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        //        button.translatesAutoresizingMaskIntoConstraints = false
        //        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        button.setTitle("Exit", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
        
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        cancelButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
//        
//        let cancelBarButton = UIBarButtonItem(customView: cancelButton)
//        navigationItem.setLeftBarButton(cancelBarButton, animated: true)
        
        
        // Register cell classes
        self.collectionView!.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        navigationItem.title = "Chats"
        
    }
    
    
    func handleCancel(){
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ChatCollectionViewCell
        
        cell.backgroundColor = .white
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let messagesVC = ChatLogCollectionViewController(collectionViewLayout: layout)
        self.navigationController?.pushViewController(messagesVC, animated: true)
        
        
    }
    



    
}
