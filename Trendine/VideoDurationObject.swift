//
//  VideoDurationObject.swift
//  Trendin
//
//  Created by Rockson on 6/27/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit


class VideoDurationObject: NSObject {
    
    
    override init() {
        super.init()
    }
    
    
    func calcVideoDuration(videoDuration: Int, videoDurationLabel: UILabel) {
        
        if videoDuration < 300 {
            
            
            if videoDuration == 60 {
                
                videoDurationLabel.text = "\(01):\(00)"
                
                
            }else if videoDuration < 60 {
                
                videoDurationLabel.text = "\(00):\(videoDuration)"
                
            }else if videoDuration > 60 {
                
                let deductedTime = videoDuration - 60
                if deductedTime < 60 {
                    
                    videoDurationLabel.text = "\(01):\(deductedTime)"
                    
                }else if deductedTime == 60 {
                    
                    videoDurationLabel.text = "\(02):\(00)"
                    
                }else if deductedTime > 60 {
                    
                    let deductAgain = deductedTime - 60
                    if deductAgain < 60 {
                        
                        videoDurationLabel.text = "\(02):\(deductAgain)"
                        
                    }else if deductAgain == 60 {
                        
                        
                        videoDurationLabel.text = "\(03):\(00)"
                        
                    }else if deductAgain > 60 {
                        
                        let deductAgainAndAgain = deductAgain - 60
                        if deductAgainAndAgain < 0 {
                            
                            videoDurationLabel.text = "\(03):\(deductAgainAndAgain)"
                            
                            
                        }else if deductAgainAndAgain == 60 {
                            
                            videoDurationLabel.text = "\(04):\(00)"
                            
                            
                        }else if deductAgainAndAgain > 60 {
                            
                            
                            videoDurationLabel.text = "\(04):\(deductAgainAndAgain)"
                            
                        }
                        
                        
                    }
                    
                    
                    
                }
                
            }
            
            
        }
        
        
    }
    
}
