//
//  PopDisplayImageView.swift
//  Trendine
//
//  Created by Rockson on 21/12/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class PopDisplayImageView: NSObject, UIScrollViewDelegate {
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    var zoomingImageView: UIImageView?
    
    lazy var  scrollView: UIScrollView = {
        let sc = UIScrollView()
        sc.delegate = self
        sc.translatesAutoresizingMaskIntoConstraints = false
//        sc.alpha = 0
        sc.minimumZoomScale = 1.0
        sc.maximumZoomScale = 6.0
        sc.backgroundColor = .clear
        return sc
        
    }()
    
    
    override init() {
        super.init()
        
    
        
        
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomingImageView
    }

    
    func acceptAndLoadDisplayImage(imageView: UIImageView){
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            keyWindow.addSubview(self.scrollView)
            scrollView.leftAnchor.constraint(equalTo: keyWindow.leftAnchor).isActive = true
            scrollView.topAnchor.constraint(equalTo:  keyWindow.topAnchor).isActive = true
            scrollView.heightAnchor.constraint(equalTo: keyWindow.heightAnchor).isActive = true
            scrollView.widthAnchor.constraint(equalTo: keyWindow.widthAnchor).isActive = true
            
            
        
        
        
            self.startingImageView = imageView
            self.startingImageView?.isHidden = true
            
            startingFrame = imageView.superview?.convert((imageView.frame), to: nil)
            
            zoomingImageView = UIImageView(frame: startingFrame!)
            zoomingImageView?.contentMode = .scaleAspectFit
            zoomingImageView?.image = imageView.image
            zoomingImageView?.isUserInteractionEnabled = true
            zoomingImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
            zoomingImageView?.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleSaveImageLongTap)))
        
            
            //            scrollView.delegate = self
            //            scrollView.minimumZoomScale = 1.0
            //            scrollView.maximumZoomScale = 6.0
        
        
        
//                blackBackgroundView = UIView(frame: keyWindow.frame)
                scrollView.backgroundColor = UIColor.black
                scrollView.alpha = 0
//                keyWindow.addSubview(blackBackgroundView!)
                self.scrollView.addSubview(self.zoomingImageView!)

                
                
                
                //                scrollView = UIScrollView(frame: keyWindow.frame)
                //                scrollView.backgroundColor = .black
                //                scrollView.alpha = 0
                //
                //                keyWindow.addSubview(scrollView)
//                keyWindow.addSubview(zoomingImageView!)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
//                    scrollView.isHidden = false
                    self.scrollView.alpha = 1
                    //                    self.scrollView.alpha = 1
//                    self.inputViewContainer.alpha = 0
                    
                    // math?
                    // h2 / w1 = h1 / w1
                    // h2 = h1 / w1 * w1
                    let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                    
                    self.zoomingImageView?.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                    
                    self.zoomingImageView?.center = keyWindow.center
                    
                }, completion: { (completed) in
                    //                    do nothing
                    
                    UIApplication.shared.setStatusBarHidden(true, with: .slide)
                    
                })
                
            }
            
        
        
        
    }
    
    
    func handleZoomOut(tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            //need to animate back out to controller
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.scrollView.alpha = 0
                zoomOutImageView.frame = self.startingFrame!
//                self.inputViewContainer.alpha = 1
                //                self.scrollView.alpha = 0
                
                
            }, completion: { (completed) in
                
                zoomOutImageView.removeFromSuperview()
//                self.scrollView.alpha = 0
                self.scrollView.removeFromSuperview()
                self.startingImageView?.isHidden = false
                UIApplication.shared.setStatusBarHidden(false, with: .slide)
                
            })
        }
    }
    
  
    let slideAlert = SlideUpActionSheet()

    
    func handleSaveImageLongTap(gesture: UILongPressGestureRecognizer){
        
        if let imageView = gesture.view as? UIImageView {
            
            if gesture.state == .began {
                
                if let image = imageView.image {
                    
                    self.slideAlert.setUpSlideView(image: image)
                    
                    
                }
                
                
            }
            
            
        }
        
        
    }
    
}
