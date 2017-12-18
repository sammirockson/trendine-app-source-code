//
//  ChatsHeaderCollectionReusableView.swift
//  Trendine
//
//  Created by Rockson on 08/02/2017.
//  Copyright © 2017 RockzAppStudio. All rights reserved.
//

import UIKit

class ChatsHeaderCollectionReusableView: UICollectionReusableView {
    
    var searchButton: UIButton = {
        let button = UIButton()
        button.contentMode = .scaleAspectFill
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.setBackgroundImage(#imageLiteral(resourceName: "SearchBar"), for: .normal)
        return button
        
    }()


    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        setUpViews()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setUpViews(){
        
        
        self.addSubview(searchButton)
        
        searchButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        searchButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        searchButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
    }
        
}
