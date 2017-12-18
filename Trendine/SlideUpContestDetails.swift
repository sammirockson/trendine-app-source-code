//
//  SlideUpContestDetails.swift
//  Trendine
//
//  Created by Rockson on 26/12/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit


class SlideUpContestDetails: NSObject {
    
    let slideBackgroundView: UIView = {
        let sd = UIView()
        sd.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        return sd
        
    }()
    
    let slideView: UIView = {
        let sd = UIView()
        sd.backgroundColor = .white
        sd.layer.cornerRadius = 5
        sd.clipsToBounds = true
        sd.isUserInteractionEnabled = true
        sd.translatesAutoresizingMaskIntoConstraints = false
        return sd
        
    }()

    
    lazy var exitButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setBackgroundImage(UIImage(named: "DeleteButton"), for: .normal)
        btn.addTarget(self, action: #selector(handleSlideDown), for: .touchUpInside)
        return btn
        
    }()
    
    override init() {
        super.init()
        
        
    }
    
    func handleSlideDown(){
        
        print("trying to slide down...")
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.slideBackgroundView.frame = CGRect(x: 0, y: -(10), width: self.slideBackgroundView.frame.width, height: self.slideBackgroundView.frame.height)
                
                
            }, completion: nil)
            
            
        }
        
       
    }
    


    func slideUpView(){
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
//            slideView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSlideDown)))
            
            keyWindow.addSubview(slideBackgroundView)
            slideBackgroundView.addSubview(slideView)
            
            
            slideView.centerXAnchor.constraint(equalTo: slideBackgroundView.centerXAnchor).isActive = true
            slideView.centerYAnchor.constraint(equalTo: slideBackgroundView.centerYAnchor).isActive = true
            slideView.widthAnchor.constraint(equalTo: slideBackgroundView.widthAnchor, constant: -20).isActive = true
            slideView.heightAnchor.constraint(equalTo: slideBackgroundView.heightAnchor, constant: -100).isActive = true
            
            slideView.addSubview(exitButton)
            
            exitButton.topAnchor.constraint(equalTo: slideView.topAnchor).isActive = true
            exitButton.leftAnchor.constraint(equalTo: slideView.leftAnchor).isActive = true
            exitButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            exitButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
//            slideView.addSubview(cancelButton)
       
            
            
//            sendToChatButton.topAnchor.constraint(equalTo: saveImageButton.bottomAnchor, constant: 1).isActive = true
//            sendToChatButton.widthAnchor.constraint(equalTo: slideView.widthAnchor).isActive = true
//            sendToChatButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
//            sendToChatButton.centerXAnchor.constraint(equalTo: slideView.centerXAnchor).isActive = true
//            
//            saveImageButton.topAnchor.constraint(equalTo: slideView.topAnchor).isActive = true
//            saveImageButton.widthAnchor.constraint(equalTo: slideView.widthAnchor).isActive = true
//            saveImageButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
//            saveImageButton.centerXAnchor.constraint(equalTo: slideView.centerXAnchor).isActive = true
//            
//            cancelButton.bottomAnchor.constraint(equalTo: slideView.bottomAnchor, constant: 8).isActive = true
//            cancelButton.widthAnchor.constraint(equalTo: slideView.widthAnchor).isActive = true
//            cancelButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
//            cancelButton.centerXAnchor.constraint(equalTo: slideView.centerXAnchor).isActive = true
//            
//            
//            
//            slideBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissViews)))
            
            
//            slideView.frame = slideBackgroundView.frame
//            slideBackgroundView.alpha = 0
            
            let width: CGFloat = keyWindow.frame.width
            let height: CGFloat = keyWindow.frame.height
            
            slideBackgroundView.frame = CGRect(x: 0, y: height, width: width, height: height)
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
//                self.slideBackgroundView.alpha = 1
                self.slideBackgroundView.frame = CGRect(x: 0, y: 0, width: width, height: height)
                
                
            }, completion: nil)
            
        }
        
        
    }
    
}
