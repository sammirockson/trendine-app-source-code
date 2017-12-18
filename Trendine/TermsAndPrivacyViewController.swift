//
//  TermsAndPrivacyViewController.swift
//  Trendin
//
//  Created by Rockson on 07/12/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class TermsAndPrivacyViewController: UIViewController {
    
    let TermsTextView: UITextView = {
       let txt = UITextView()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.dataDetectorTypes = .all
        txt.backgroundColor = .white
        txt.isEditable = false
        return txt
        
    }()
    
    
    var isIncomingVCTerms: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpView()
        
        if isIncomingVCTerms == true {
            
            navigationItem.title = "Terms Of Service"
  
        }else{
            
            
            navigationItem.title = "Privacy"

        }
        
        
        
        let query = BmobQuery(className: "Privacy")
        query?.findObjectsInBackground({ (results, error) in
            if error == nil {
                
                if let firstobject = results?.first as? BmobObject {
                    
                    DispatchQueue.main.async {
                        
                        if self.isIncomingVCTerms == true {
                          
                            if  let terms = firstobject.object(forKey: "Terms") as? String{
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MMMM dd, yyyy, EEEE h:mm a"
                                let stringFromDate = dateFormatter.string(from: firstobject.updatedAt)
                                
                                self.TermsTextView.text = "Last updated on \(stringFromDate) \n\(terms)"
                            }
                            
                        }else{
                            
                            
                            
                            if  let privacy = firstobject.object(forKey: "Privacy") as? String{
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MMMM dd, yyyy, EEEE h:mm a"
                                let stringFromDate = dateFormatter.string(from: firstobject.updatedAt)
                                
                                self.TermsTextView.text = "Last updated on \(stringFromDate) \n\(privacy)"
                            }
                        }
                     
                       
                        
                        
                    }
                }
                
            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func handleLeftBarButton(){
        
       self.dismiss(animated: true, completion: nil)
        
    }
    
    func setUpView(){
        
     self.view.addSubview(TermsTextView)
        
        TermsTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        TermsTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        TermsTextView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        TermsTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
        
    }

   

}
