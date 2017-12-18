//
//  DateFormmater.swift
//  Trendin
//
//  Created by Rockson on 8/3/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class DateFormmater: NSObject {
    

    func DateFormatting(createdAt: NSDate, timeStamp: UILabel){
        
        let date2 = createdAt
        let date1 = NSDate()
        
        let diffDateComponents = Calendar.current.dateComponents([.day, .hour , .minute , .second], from: date2 as Date, to: date1 as Date)
        
      
        let days = diffDateComponents.day
        let dateByMins = diffDateComponents.minute
        let hourHand = diffDateComponents.hour
        
        
        if let day = days ,let hour = hourHand, let mins = dateByMins{
            
            if day < 1 {
                
                switch hour {
                    
                case 0:
                    
                timeStamp.text = "\(mins) mins ago"
                    
                case 1:
                    
                timeStamp.text = "1 hour ago"
                    
                    
                default:
                    
                    timeStamp.text = "\(hour) hours ago"
                }
                
                
                
            }else if day >= 1 {
                
                timeStamp.text = ""
                
            }
            
            
        }
        
    }


}
