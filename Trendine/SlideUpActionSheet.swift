//
//  SlideUpActionSheet.swift
//  Trendin
//
//  Created by Rockson on 10/12/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit


class SlideUpActionSheet: NSObject {
    
    let slideBackgroundView: UIView = {
        let sd = UIView()
        sd.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return sd
        
    }()
    
    let slideView: UIView = {
       let sd = UIView()
        sd.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return sd
        
    }()
    
    lazy var saveImageButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Save", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = UIColor(white: 0.9, alpha: 0.9)
        btn.addTarget(self, action: #selector(handleSaveImage), for: .touchUpInside)
        return btn
        
    }()
    
    
//    let sendToChatButton: UIButton = {
//        let btn = UIButton()
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        btn.setTitle("Send To Chat", for: .normal)
//        btn.setTitleColor(.black, for: .normal)
//        btn.titleLabel?.textAlignment = .center
//        btn.backgroundColor = UIColor(white: 0.9, alpha: 0.9)
//        return btn
//        
//    }()
    
    
    lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Cancel", for: .normal)
        btn.backgroundColor = UIColor(white: 0.9, alpha: 0.9)
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(handleDismissViews), for: .touchUpInside)
        return btn
        
    }()
    
    let blurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.layer.cornerRadius = 8
        bView.clipsToBounds = true
        return bView
        
    }()
    
    
    let displayText: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 18)
        lb.textAlignment = .center
        lb.text = "Saved"
        return lb
        
    }()
    
    var imageToBeSaved: UIImage?
    
    override init() {
        super.init()
    }
    
    
    func handleSaveImage(){
        
        if let image = imageToBeSaved {
            
          UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
          self.handleDismissViews()
            Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: false)
          
        }
       
        
    }
    
    func handleFinishedSavingImage(){
        
        print("image saved")
        
        self.handleDismissViews()
        
        
        
    }
    
    func handleTimer(){
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            keyWindow.addSubview(blurView)
            
            blurView.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor).isActive = true
            blurView.centerYAnchor.constraint(equalTo: keyWindow.centerYAnchor).isActive = true
            blurView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            blurView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
            blurView.addSubview(displayText)
            
            displayText.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor).isActive = true
            displayText.centerYAnchor.constraint(equalTo: keyWindow.centerYAnchor).isActive = true
            displayText.widthAnchor.constraint(equalTo: blurView.widthAnchor).isActive = true
            displayText.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            
            Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(handleDismissTimer), userInfo: nil, repeats: false)
            
        }
        
    }
    
    func handleDismissTimer(){
        
        blurView.alpha = 1
    
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: ({
        
            self.blurView.alpha = 0

        
        }), completion:{ (success) in
            
           self.blurView.removeFromSuperview()
            
        })

   
        
    }
    
    func setUpSlideView(image: UIImage){
        
        self.imageToBeSaved = image
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            keyWindow.addSubview(slideBackgroundView)
            keyWindow.addSubview(slideView)
            
            
            slideView.addSubview(cancelButton)
            slideView.addSubview(saveImageButton)
//            slideView.addSubview(sendToChatButton)
            
            
            
            saveImageButton.topAnchor.constraint(equalTo: slideView.topAnchor).isActive = true
            saveImageButton.widthAnchor.constraint(equalTo: slideView.widthAnchor).isActive = true
            saveImageButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
            saveImageButton.centerXAnchor.constraint(equalTo: slideView.centerXAnchor).isActive = true
            
            cancelButton.bottomAnchor.constraint(equalTo: slideView.bottomAnchor, constant: 8).isActive = true
            cancelButton.widthAnchor.constraint(equalTo: slideView.widthAnchor).isActive = true
            cancelButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
            cancelButton.centerXAnchor.constraint(equalTo: slideView.centerXAnchor).isActive = true
            
            
            
            slideBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissViews)))
            slideBackgroundView.frame = keyWindow.frame
            slideBackgroundView.alpha = 0
            
            
            slideView.frame = CGRect(x: 0, y: keyWindow.frame.height - 8, width: keyWindow.frame.width, height: 100)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.slideBackgroundView.alpha = 1
                self.slideView.frame = CGRect(x: 0, y: keyWindow.frame.height - 108, width: keyWindow.frame.width, height: 100)
 
                
            }, completion: nil)
            
        }
        
    }
    
    func handleDismissViews(){
        
        if let keyWindow = UIApplication.shared.keyWindow {

        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.slideBackgroundView.alpha = 0
            self.slideView.frame = CGRect(x: 0, y: keyWindow.frame.height, width: keyWindow.frame.width, height: 140)
            
            
        }, completion: nil)
            
     }
        
    }
    
    
}
