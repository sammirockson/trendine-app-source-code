//
//  UpdateUserInfoViewController.swift
//  Trendin
//
//  Created by Rockson on 04/11/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class UpdateUserInfoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let inputContainerView: UIView = {
        let inPutView = UIView()
        inPutView.backgroundColor = UIColor.clear
        inPutView.translatesAutoresizingMaskIntoConstraints = false
        return inPutView
        
    }()
    

    
    lazy var profileImageView: UIImageView = {
        
        let profileImageV = UIImageView()
        profileImageV.contentMode = .scaleAspectFill
        profileImageV.layer.cornerRadius = 4
        profileImageV.layer.masksToBounds = true
        profileImageV.translatesAutoresizingMaskIntoConstraints = false
        profileImageV.image = UIImage(named: "personplaceholder")
        profileImageV.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImagePicker)))
        profileImageV.isUserInteractionEnabled = true
        return profileImageV
        
    }()
    
    
    let blurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        bView.translatesAutoresizingMaskIntoConstraints = false
        bView.layer.cornerRadius = 5
        bView.clipsToBounds = true
        return bView
        
    }()
    


    let activityIndicator: UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        ac.translatesAutoresizingMaskIntoConstraints = false
        ac.hidesWhenStopped = true
        return ac
        
        
    }()
    
    let backgroundBlurView: UIView = {
        let bView = UIView()
        bView.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
        bView.translatesAutoresizingMaskIntoConstraints = false
        return bView
        
    }()
    
    
    var newName: String?
    var newPassword: String?
    var newImage: UIImage?
    
    var rightBarButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            keyWindow.addSubview(backgroundBlurView)
            backgroundBlurView.addSubview(blurView)
            keyWindow.addSubview(activityIndicator)
            
            blurView.addSubview(activityIndicator)
            
            backgroundBlurView.topAnchor.constraint(equalTo: keyWindow.topAnchor).isActive = true
            backgroundBlurView.leftAnchor.constraint(equalTo: keyWindow.leftAnchor).isActive = true
            backgroundBlurView.widthAnchor.constraint(equalTo: keyWindow.widthAnchor).isActive = true
            backgroundBlurView.heightAnchor.constraint(equalTo: keyWindow.heightAnchor).isActive = true
            
            activityIndicator.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
            activityIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
            activityIndicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            blurView.centerYAnchor.constraint(equalTo: keyWindow.centerYAnchor).isActive = true
            blurView.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor).isActive = true
            blurView.widthAnchor.constraint(equalToConstant: 120).isActive = true
            blurView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            
            backgroundBlurView.isHidden = true
            
        }
            
       
        
        
        navigationItem.title = "Update info"
        
         rightBarButton = UIBarButtonItem(title: "Update", style: .done, target: self, action: #selector(handleRightBarButton))
        navigationItem.setRightBarButton(rightBarButton, animated: true)
        rightBarButton?.isEnabled = false
        
        setUpViews()
        
        if let profileImageData = UserDefaults.standard.object(forKey: "profileImageData") as? NSData {
            
            profileImageView.image = UIImage(data: profileImageData as Data)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        rightBarButton?.isEnabled = true

        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
           self.profileImageView.image = image
        }
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            self.profileImageView.image = image
 
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleImagePicker(){
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
        
    }
    
    
    func handleRightBarButton(){
        
        
        if let profileImageData = UserDefaults.standard.object(forKey: "profileImageData") as? NSData {
            
            let image = UIImage(data: profileImageData as Data)
            
            self.activityIndicator.startAnimating()
            self.backgroundBlurView.isHidden = false
            
            if self.profileImageView.image != image && self.profileImageView.image != nil {
                
                let newImageData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.2)
                
                let imageFile = BmobFile(fileName: "image.JPG", withFileData: newImageData)
                imageFile?.save(inBackground: { (success, error) in
                    if success{
                        
                    let currentUser = BmobUser.current()
                        currentUser?.setObject(imageFile, forKey: "profileImageFile")
                        currentUser?.updateInBackground(resultBlock: { (success, error) in
                            if success{
                                
                                print("user info updated successfully")
                                
                                
                                UserDefaults.standard.setValue(newImageData, forKey: "profileImageData")
                                
                                self.activityIndicator.stopAnimating()
                                self.backgroundBlurView.isHidden = true

                                

                            }
                        })
                        
                        
                        
                    }else{
                        
                        self.activityIndicator.stopAnimating()
                        self.backgroundBlurView.isHidden = true
                        print(error?.localizedDescription as Any)
                    }
                })
                
            }else{
                
                self.activityIndicator.stopAnimating()
                self.backgroundBlurView.isHidden = true
            }
            
          
            
            
        }else{
            
            
            self.activityIndicator.stopAnimating()
            self.backgroundBlurView.isHidden = true
        }
        
        
    
        
        
    }

    func setUpViews(){
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(inputContainerView)
        view.addSubview(profileImageView)
        
    
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant:  0).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        profileImageView.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor, constant:  -30).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: inputContainerView.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
     
        
    }


}
