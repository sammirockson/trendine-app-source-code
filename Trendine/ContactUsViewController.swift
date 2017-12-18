//
//  ContactUsViewController.swift
//  Trendine
//
//  Created by Rockson on 07/01/2017.
//  Copyright © 2017 RockzAppStudio. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    
    
    lazy var selectImageIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.image = #imageLiteral(resourceName: "AddIcon")
        image.isUserInteractionEnabled = true
        image.layer.cornerRadius = 4
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChooseImage)))
        return image
    }()
    
    
    lazy var contentTextView: UITextView = {
       let textV = UITextView()
        textV.translatesAutoresizingMaskIntoConstraints = false
        textV.layer.borderColor = UIColor(white: 0.1, alpha: 0.5).cgColor
        textV.layer.borderWidth = 1
        textV.clipsToBounds = true
        textV.layer.cornerRadius = 5
        textV.delegate = self
        textV.backgroundColor = .clear
        textV.font = UIFont.systemFont(ofSize: 16)
        return textV
        
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
    
    let displayText: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.textAlignment = .center
        lb.text = "Sending..."
        return lb
        
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        ac.translatesAutoresizingMaskIntoConstraints = false
        ac.hidesWhenStopped = true
        return ac
        
    }()

    var rightBarButton: UIBarButtonItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        rightBarButton = UIBarButtonItem(title: "Send", style: .done, target: self, action: #selector(handleRightBarButton))
        rightBarButton?.isEnabled = false
        self.navigationItem.setRightBarButton(rightBarButton, animated: true)
        
        contentTextView.text = "Please describe the problem and attach screenshot if possible"
        contentTextView.textColor = .lightGray
        
        navigationItem.title = "Contact Us"
        self.setUpViews()
        
        
        self.view.addSubview(blurView)
        
        blurView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blurView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        blurView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        blurView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        blurView.addSubview(activityIndicator)
        blurView.addSubview(displayText)
        
        displayText.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8).isActive = true
        displayText.leftAnchor.constraint(equalTo: blurView.leftAnchor).isActive = true
        displayText.rightAnchor.constraint(equalTo: blurView.rightAnchor).isActive = true
        displayText.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        activityIndicator.centerXAnchor.constraint(equalTo: blurView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: blurView.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 25).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        blurView.isHidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func handleRightBarButton(){
        
        if self.contentTextView.text != "" || selectImageIcon.image != nil {
            
            if selectImageIcon.image != #imageLiteral(resourceName: "AddIcon") && selectImageIcon.image != nil {
               
                if let imageData = UIImageJPEGRepresentation(self.selectImageIcon.image!, 1.0) {
                    
                    blurView.isHidden = false
                    self.activityIndicator.startAnimating()

                    
                    let imageFile = BmobFile(fileName: "image.JPG", withFileData: imageData)
                    imageFile?.save(inBackground: { (success, error) in
                        if success {
                            
                            let support = BmobObject(className: "Support")
                            if let content = self.contentTextView.text {
                                
                                support?.setObject(content, forKey: "content")
                            }
                            support?.setObject(imageFile, forKey: "screenShot")
                            support?.saveInBackground(resultBlock: { (success, error) in
                                if success {
                                    
                                    
                                    self.blurView.isHidden = true
                                    self.activityIndicator.stopAnimating()
                                    
                                    self.alert(reason: "Thank you. Message received, we will act on it as soon as possible")
                                    
                                }else{
                                    
                                    self.blurView.isHidden = true
                                    self.activityIndicator.stopAnimating()
                                    self.alert(reason: error?.localizedDescription as Any as! String)
                                    
                                    
                                }
                            })
                            
                            
                        }else{
                            
                            self.blurView.isHidden = true
                            self.activityIndicator.stopAnimating()
                            self.alert(reason: error?.localizedDescription as Any as! String)
                        }
                    })
                    
                    
                }
                
            }else{
                
                if self.contentTextView.text != "" {
                  
                    self.blurView.isHidden = false
                    self.activityIndicator.startAnimating()
                    
                    let support = BmobObject(className: "Support")
                    if let content = self.contentTextView.text {
                        
                        support?.setObject(content, forKey: "content")
                    }
                    support?.saveInBackground(resultBlock: { (success, error) in
                        if success {
                            
                            self.blurView.isHidden = true
                            self.activityIndicator.stopAnimating()
                            
                            self.alert(reason: "Thank you. Message received, we will act on it as soon as possible")
                            
                            
                        }else{
                            
                            self.blurView.isHidden = true
                            self.activityIndicator.stopAnimating()
                            self.alert(reason: error?.localizedDescription as Any as! String)
                            
                            
                        }
                    })
                    
                }else{
                    
                    self.alert(reason: "Text field cannot be empty")
                    
                }
               
               
                
            }
            
          
    
        }
        
    }
    
    
    
    func alert(reason: String){
        
        let alert = UIAlertController(title: reason, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.contentTextView.textColor = .black
        self.contentTextView.text = ""
        self.rightBarButton?.isEnabled = true

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.rightBarButton?.isEnabled = true
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            self.selectImageIcon.image = editedImage
            
            
            
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
           self.selectImageIcon.image = originalImage
            
        }
        
        self.dismiss(animated: true, completion: nil)


    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleChooseImage(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
        
        
    }
    
    func setUpViews(){
      
        self.view.addSubview(contentTextView)
        self.view.addSubview(selectImageIcon)
        
        selectImageIcon.bottomAnchor.constraint(equalTo: contentTextView.topAnchor, constant: -10).isActive = true
        selectImageIcon.centerXAnchor.constraint(equalTo: contentTextView.centerXAnchor).isActive = true
        selectImageIcon.widthAnchor.constraint(equalToConstant: 80).isActive = true
        selectImageIcon.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        contentTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        contentTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        contentTextView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        contentTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        
        
    }

    
}
