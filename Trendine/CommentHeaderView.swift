//
//  CommentHeaderView.swift
//  Trendin
//
//  Created by Rockson on 10/22/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import Foundation


class CommentHeaderView: UICollectionReusableView {
    
    
    let loadMoreButton: UIButton = {
      let button = UIButton(type: .system)
        button.setTitle("Load earlier comments...", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpViews()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpViews(){
     
    self.backgroundColor = .white
     
    self.addSubview(loadMoreButton)
    
        loadMoreButton.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        loadMoreButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        loadMoreButton.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        loadMoreButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        

        
    }
}
