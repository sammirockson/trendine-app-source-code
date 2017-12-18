//
//  PopUpAndPlayVideo.swift
//  Trendin
//
//  Created by Rockson on 13/12/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import AVFoundation


class PopUpAndPlayVideo: NSObject {
    
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    
    let videoBlackBackground: UIView = {
        let vidBg = UIView()
        vidBg.backgroundColor = .black
        return vidBg
        
    }()
    
    
    let videoScreen: UIView = {
        let vidBg = UIView()
        vidBg.backgroundColor = .black
        vidBg.translatesAutoresizingMaskIntoConstraints = false
        return vidBg
        
    }()
    
    
    lazy var  transparentVideoScreen: UIView = {
        let vidBg = UIView()
        vidBg.backgroundColor = .clear
        vidBg.translatesAutoresizingMaskIntoConstraints = false
        vidBg.isUserInteractionEnabled = true
        vidBg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleControlsContainerViewTapped)))
        return vidBg
        
    }()
    
    lazy var replayVideoPlayButton: UIButton = {
        let vidBg = UIButton()
        let image = UIImage(named: "pause")
        vidBg.setBackgroundImage(image, for: .normal)
        vidBg.clipsToBounds = true
        vidBg.translatesAutoresizingMaskIntoConstraints = false
        vidBg.addTarget(self, action: #selector(handlePausePlayVideo), for: .touchUpInside)
        vidBg.layer.cornerRadius = 20
        return vidBg
        
    }()
    
    lazy var exitVideoPlay: UIButton = {
        let vidBg = UIButton()
        let image = UIImage(named: "DeleteButton")
        vidBg.setBackgroundImage(image, for: .normal)
        vidBg.clipsToBounds = true
        vidBg.translatesAutoresizingMaskIntoConstraints = false
        vidBg.addTarget(self, action: #selector(handleExitVideoPlay), for: .touchUpInside)
        vidBg.isHidden  = true
        return vidBg
        
    }()
    
    let numberOfViewsLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .gray
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textAlignment = .left
        return lb
        
    }()
    
    let numberOfViewsImageView: UIImageView = {
        let vidBg = UIImageView()
        vidBg.image = UIImage(named: "play")
        vidBg.contentMode = .scaleAspectFill
        vidBg.translatesAutoresizingMaskIntoConstraints = false
        vidBg.clipsToBounds = true
        return vidBg
        
    }()
    
    let videoRightTimeLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.text = "00:00"
        lb.textAlignment = .center
        lb.isHidden = true
        return lb
        
    }()
    
    static let redPinkColor = UIColor(patternImage: UIImage(named: "NumberOfNotificationBG")!)
    
    
    let videoLeftTimeLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.text = "00:00"
        lb.textAlignment = .center
        lb.isHidden = true
        return lb
        
    }()
    
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = UIColor(red: 241/255, green: 5/255, blue: 95/255, alpha: 1)
        slider.thumbTintColor = redPinkColor
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        slider.isHidden = true
        return slider
        
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let ac = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        ac.translatesAutoresizingMaskIntoConstraints = false
        ac.hidesWhenStopped = true
        return ac
        
        
    }()
    
    
    var incomingURL: NSURL?
    
    
    
    lazy var optionsButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "options"), for: .normal)
//        button.addTarget(self, action: #selector(handleOptionsButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
        
    }()
    
    var playedVideoUrl: NSURL?
    
    func handleSliderChange(sender: UISlider) {
        
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            
            let value = Float64(sender.value) * totalSeconds
            
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                
            })
        }
        
        
    }
    
    
    func handlePausePlayVideo(sender: UIButton){
        
        if sender.currentBackgroundImage == UIImage(named: "play") {
            sender.setBackgroundImage(UIImage(named: "pause"), for: .normal)
            sender.isHidden = true
            
            if self.player != nil {
                
                self.player?.play()
            }
            
        }else if sender.currentBackgroundImage == UIImage(named: "pause"){
            sender.setBackgroundImage(UIImage(named: "play"), for: .normal)
            sender.isHidden = true

            
            if self.player != nil {
                
                self.player?.pause()
            }
            
            
            
            
        }
        
        
    }
    
    
    var videoURL: String?
    
    override init() {
        super.init()
        
  
    }
    
    
//    func handleOptionsButtonTapped(){
//        
//        if let url = videoURL {
//        
//    
////        UISaveVideoAtPathToSavedPhotosAlbum(url, nil, nil, nil)
//   
//            
//        }
//        
//        
//    }
//    
    
    func handleExitVideoPlay(){
        
        self.handleHideVideo()
    }
    
    
    func handleControlsContainerViewTapped(){
        
        exitVideoPlay.isHidden = false
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(showHidden), userInfo: nil, repeats: false)
    
    
    }
    
    func showHidden(){
      
        exitVideoPlay.isHidden = true

        
    }
    
    func handlePopVideoToSecreenAndPlay(url: NSURL, selectedObjectId: String){
        replayVideoPlayButton.isHidden = true
        self.videoURL = url.absoluteString
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            keyWindow.addSubview(videoBlackBackground)
            videoBlackBackground.frame = keyWindow.bounds
            videoBlackBackground.addSubview(activityIndicator)
            
            
            
            activityIndicator.centerYAnchor.constraint(equalTo: videoBlackBackground.centerYAnchor).isActive = true
            activityIndicator.centerXAnchor.constraint(equalTo: videoBlackBackground.centerXAnchor).isActive = true
            activityIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true
            activityIndicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            videoBlackBackground.alpha = 0
            
    
      
        transparentVideoScreen.addSubview(replayVideoPlayButton)
        replayVideoPlayButton.centerXAnchor.constraint(equalTo: transparentVideoScreen.centerXAnchor).isActive = true
        replayVideoPlayButton.centerYAnchor.constraint(equalTo: transparentVideoScreen.centerYAnchor).isActive = true
        replayVideoPlayButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        replayVideoPlayButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
        transparentVideoScreen.addSubview(exitVideoPlay)
        exitVideoPlay.topAnchor.constraint(equalTo: transparentVideoScreen.topAnchor, constant: 20).isActive = true
        exitVideoPlay.leftAnchor.constraint(equalTo: transparentVideoScreen.leftAnchor, constant: 10).isActive = true
        exitVideoPlay.widthAnchor.constraint(equalToConstant: 30).isActive = true
        exitVideoPlay.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        transparentVideoScreen.addSubview(optionsButton)
        optionsButton.rightAnchor.constraint(equalTo: transparentVideoScreen.rightAnchor, constant: -5).isActive = true
        optionsButton.centerYAnchor.constraint(equalTo: exitVideoPlay.centerYAnchor).isActive = true
        optionsButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        optionsButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        transparentVideoScreen.addSubview(numberOfViewsImageView)
        numberOfViewsImageView.leftAnchor.constraint(equalTo: exitVideoPlay.rightAnchor, constant: 30).isActive = true
        numberOfViewsImageView.centerYAnchor.constraint(equalTo: exitVideoPlay.centerYAnchor).isActive = true
        numberOfViewsImageView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        numberOfViewsImageView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        transparentVideoScreen.addSubview(numberOfViewsLabel)
        numberOfViewsLabel.leftAnchor.constraint(equalTo: numberOfViewsImageView.rightAnchor, constant: 5).isActive = true
        numberOfViewsLabel.rightAnchor.constraint(equalTo: optionsButton.leftAnchor).isActive = true
        numberOfViewsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        numberOfViewsLabel.centerYAnchor.constraint(equalTo: numberOfViewsImageView.centerYAnchor).isActive = true
        
        
        transparentVideoScreen.addSubview(videoRightTimeLabel)
        videoRightTimeLabel.rightAnchor.constraint(equalTo: transparentVideoScreen.rightAnchor).isActive = true
        videoRightTimeLabel.bottomAnchor.constraint(equalTo: transparentVideoScreen.bottomAnchor, constant: -15).isActive = true
        videoRightTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        videoRightTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        transparentVideoScreen.addSubview(videoLeftTimeLabel)
        videoLeftTimeLabel.leftAnchor.constraint(equalTo: transparentVideoScreen.leftAnchor).isActive = true
        videoLeftTimeLabel.bottomAnchor.constraint(equalTo: transparentVideoScreen.bottomAnchor, constant: -15).isActive = true
        videoLeftTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        videoLeftTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        transparentVideoScreen.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoRightTimeLabel.leftAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: videoLeftTimeLabel.rightAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 20).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: transparentVideoScreen.bottomAnchor, constant: -15).isActive = true
        
        keyWindow.addSubview(self.transparentVideoScreen)
        self.transparentVideoScreen.centerYAnchor.constraint(equalTo: keyWindow.centerYAnchor).isActive = true
        self.transparentVideoScreen.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor).isActive = true
        self.transparentVideoScreen.widthAnchor.constraint(equalTo: keyWindow.widthAnchor).isActive = true
        self.transparentVideoScreen.heightAnchor.constraint(equalTo: keyWindow.heightAnchor).isActive = true
        
            self.transparentVideoScreen.alpha = 1

        self.searchForNumberOfViewsInBackend(objectId: selectedObjectId)
        
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                
                self.videoBlackBackground.alpha = 1
                self.activityIndicator.startAnimating()
                
                    self.incomingURL = url
                
                    self.player = AVPlayer(url: url as URL)
                    self.playerLayer = AVPlayerLayer(player: self.player)
                    self.playerLayer?.frame = self.videoBlackBackground.bounds
                    self.videoBlackBackground.layer.addSublayer(self.playerLayer!)
                    self.player?.play()
                    
                    
             
                    
                    self.player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
                    
//                NotificationCenter.default.addObserver(self, selector: #selector(self.videoFinishedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
                
                NotificationCenter.default.addObserver(self,selector: #selector(self.playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
                
                
                
               
                    
                    
                    let interval = CMTime(value: 1, timescale: 2)
                    
                    self.player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime) in
                        
                        let seconds = CMTimeGetSeconds(progressTime)
                        
                        //lets move the slider thumb
                        if let duration = self.player?.currentItem?.duration {
                            let durationSeconds = CMTimeGetSeconds(duration)
                            
                            self.videoSlider.value = Float(seconds / durationSeconds)
                            
                        }
                        
                        
                        
                        
                        let secondsString = String(format: "%02d", Int(Int(seconds) % 60))
                        let minutesString = String(format: "%02d", Int(seconds / 60))
                        
                        self.videoLeftTimeLabel.text = "\(minutesString):\(secondsString)"
                        
                       
                        
                        
                        
                    })
                
                
                
            }, completion: { (success) in
                
                UIApplication.shared.setStatusBarHidden(true, with: .fade)
                
                
                
                
            })
            
            
        
        }
    
    }
    

    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
        if keyPath == "currentItem.loadedTimeRanges" {
            videoLeftTimeLabel.isHidden = false
            videoRightTimeLabel.isHidden = false
            videoSlider.isHidden = false
            
            activityIndicator.stopAnimating()
            
            if let duration = player?.currentItem?.duration {
                
                let seconds:Int = Int(CMTimeGetSeconds(duration))
                let secondsText = String(format: "%02d", Int(seconds) % 60)
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                videoRightTimeLabel.text = "\(minutesText):\(secondsText)"
                
                self.replayVideoPlayButton.isHidden = true
            }
            
        }
    }
    
    
    
    
    func playerItemDidReachEnd(notification: NSNotification) {
        
        self.player?.seek(to: kCMTimeZero)
        self.player?.play()
    }
    
    func videoFinishedPlaying(){
        
    
    }
    
    
    func handleHideVideo(){
        
    self.replayVideoPlayButton.setBackgroundImage(UIImage(named: "pause"), for: .normal)

        
        if self.player != nil {
            
            self.player?.pause()
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                
                self.videoBlackBackground.alpha = 0
                self.transparentVideoScreen.alpha = 0
                
               
                
            }, completion: { (success) in
                
                
                self.videoBlackBackground.removeFromSuperview()
                self.transparentVideoScreen.removeFromSuperview()
                self.playerLayer?.removeFromSuperlayer()
                UIApplication.shared.setStatusBarHidden(false, with: .fade)
                self.player?.removeObserver(self, forKeyPath: "currentItem.loadedTimeRanges")
                
                NotificationCenter.default.removeObserver(self)
                
                
                
            })
            
        }
        
    }
    
    
    
    func searchForNumberOfViewsInBackend(objectId: String){
        
        let query = BmobQuery(className: "Trends")
        query?.cachePolicy = kBmobCachePolicyCacheThenNetwork
        query?.getObjectInBackground(withId: objectId, block: { (object, error) in
            if error == nil {
             
                if let foundObject = object{
                  
                    
                    if var numberOfViews = foundObject.object(forKey: "numberOfViews") as? Int {
                        
                        DispatchQueue.main.async {
                            
                            self.numberOfViewsLabel.text = "\(numberOfViews) views"
                            
                        }
                        
                        numberOfViews = numberOfViews + 1
                        
                        foundObject.setObject(numberOfViews, forKey: "numberOfViews")
                        foundObject.updateInBackground(resultBlock: { (success, error) in
                            if error == nil {
                                
                             
                                print("object updated")
                                
                            }
                        })

                    }
                    
                }
                
            }else{
                
                print(error?.localizedDescription as Any)
            }
        })
        
        
    }
}
