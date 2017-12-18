//
//  ContestTimeView.swift
//  Trendin
//
//  Created by Rockson on 10/5/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import Foundation

class ContestTimeView: UICollectionReusableView {
    
    let timeHourDisplayLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
        
    }()
    
    let timeMinDisplayLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
        
    }()
    
    let timeSecsDisplayLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
        
    }()
    
    
    let timeDayDisplayLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
        
    }()
    
    let DaysCounterImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "Oval")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        
        return img
        
    }()
    
    let HourCounterImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "Oval")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true

        return img
        
    }()
    
    let MinuteCounterImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "Oval")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true

        return img
        
    }()
    
    let SecondsCounterImageView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "Oval")
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true

        return img
        
    }()
    
    
//    let MoreInfoButton: UIButton = {
//        let button = UIButton(type: .system)
//        let image = UIImage(named: "more")
//        button.setBackgroundImage(image, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.contentMode = .scaleAspectFill
//        button.clipsToBounds = true
//        return button
//        
//    }()
    
    let dividerView: UIView = {
       let divView = UIView()
        divView.backgroundColor = .clear
        divView.translatesAutoresizingMaskIntoConstraints = false
        return divView
        
    }()
    
    
    
    var mins: Int = 0
    var sec:Int = 0
    var stopTimer = false
    
    var countingTimer:  Timer = {
       let timer = Timer()
        return timer
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUpViews()
        
        self.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        
        let stringTime = String(format: "%02d", Int(00))
      
        self.timeMinDisplayLabel.text = stringTime
        self.timeSecsDisplayLabel.text = stringTime
        self.timeHourDisplayLabel.text = stringTime
        self.timeDayDisplayLabel.text = stringTime
        
        self.loadData()
        
        
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUpViews(){
        
        self.addSubview(dividerView)
        
        
        
//        self.addSubview(MoreInfoButton)
        self.addSubview(MinuteCounterImageView)
        self.addSubview(SecondsCounterImageView)
        self.addSubview(HourCounterImageView)
        self.addSubview(DaysCounterImageView)
        
        
        dividerView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        dividerView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dividerView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        dividerView.widthAnchor.constraint(equalToConstant: 8).isActive = true

        
//        MoreInfoButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
//        MoreInfoButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        MoreInfoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        MoreInfoButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        MinuteCounterImageView.addSubview(timeMinDisplayLabel)
        SecondsCounterImageView.addSubview(timeSecsDisplayLabel)
        HourCounterImageView.addSubview(timeHourDisplayLabel)
        DaysCounterImageView.addSubview(timeDayDisplayLabel)
        
        
        
        DaysCounterImageView.rightAnchor.constraint(equalTo: HourCounterImageView.leftAnchor, constant: -8).isActive = true
        DaysCounterImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        DaysCounterImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        DaysCounterImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        MinuteCounterImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        MinuteCounterImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        MinuteCounterImageView.leftAnchor.constraint(equalTo: dividerView.rightAnchor, constant: 0).isActive = true
        MinuteCounterImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        HourCounterImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        HourCounterImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        HourCounterImageView.rightAnchor.constraint(equalTo: dividerView.leftAnchor, constant: 0).isActive = true
        HourCounterImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        SecondsCounterImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        SecondsCounterImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        SecondsCounterImageView.leftAnchor.constraint(equalTo: MinuteCounterImageView.rightAnchor, constant: 8).isActive = true
        SecondsCounterImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        timeMinDisplayLabel.centerXAnchor.constraint(equalTo: MinuteCounterImageView.centerXAnchor).isActive = true
        timeMinDisplayLabel.centerYAnchor.constraint(equalTo: MinuteCounterImageView.centerYAnchor).isActive = true
        timeMinDisplayLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        timeMinDisplayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        timeSecsDisplayLabel.centerXAnchor.constraint(equalTo: SecondsCounterImageView.centerXAnchor).isActive = true
        timeSecsDisplayLabel.centerYAnchor.constraint(equalTo: SecondsCounterImageView.centerYAnchor).isActive = true
        timeSecsDisplayLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        timeSecsDisplayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        timeHourDisplayLabel.centerXAnchor.constraint(equalTo: HourCounterImageView.centerXAnchor).isActive = true
        timeHourDisplayLabel.centerYAnchor.constraint(equalTo: HourCounterImageView.centerYAnchor).isActive = true
        timeHourDisplayLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        timeHourDisplayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        timeDayDisplayLabel.centerXAnchor.constraint(equalTo: DaysCounterImageView.centerXAnchor).isActive = true
        timeDayDisplayLabel.centerYAnchor.constraint(equalTo: DaysCounterImageView.centerYAnchor).isActive = true
        timeDayDisplayLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        timeDayDisplayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    var createdTime: NSDate?
    
    func loadData(){
        
        print("loading objects...")
        
        let query = BmobQuery(className: "ContestTime")
        query?.order(byDescending: "createdAt")
        query?.limit = 1
        query?.findObjectsInBackground { (results, error) -> Void in
            if error == nil {
                
                if (results?.count)! > 0 {
                    
                    
                    for result in results! {
                        
                        if let trend = result as? BmobObject{
                            
                            DispatchQueue.main.async {
                                
                                
                                if self.stopTimer == false {
                                    
                                    self.createdTime = trend.object(forKey: "contestTime") as? NSDate
                                    
                                    
                                    self.countingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.handleCounter), userInfo: nil, repeats: true)
                                    self.countingTimer.tolerance = 0.01
                                    
                                }
                                
                                
                                
                            }
                            
                            
                        }
                    }
                    
                    
                }
                
                
            }
            
            
        }
        
    }
    
 
    func handleCounter(){
        
        if self.stopTimer == false {
            
            let calen = Calendar.current.dateComponents([.day, .hour , .minute , .second], from: self.createdTime as! Date, to: Date())
            
            let day = calen.day
            let hour = calen.hour
            let minute = calen.minute
            let second = calen.second
            
            let mins = "MINS"
            let hrs = "HOURS"
            let secs = "SECS"
            let da = "DAYS"
            
            
            if let daily = day {
                
                if daily == 5 {
                    
                    self.deleteContestTime()
                    
                    self.stopTimer = true
                    self.countingTimer.invalidate()
                    
                   
                    let stringTime = String(format: "%02d", Int(00))
                   
                    

                    

                    self.timeMinDisplayLabel.text = stringTime
                    self.timeSecsDisplayLabel.text = stringTime
                    self.timeHourDisplayLabel.text = stringTime
                    self.timeDayDisplayLabel.text = stringTime
                    
                }else{
                    
                    
                    
                    
                    let attributedMutableText4 = NSMutableAttributedString(string: String(day!), attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)])
                    
                    let atrributedText4 = NSAttributedString(string: "\n\(da)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 8), NSForegroundColorAttributeName: UIColor.red])
                    attributedMutableText4.append(atrributedText4)
                    
                    timeDayDisplayLabel.attributedText = attributedMutableText4
                    
                    
                    let attributedMutableText2 = NSMutableAttributedString(string: String(hour!), attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)])
                    
                    let atrributedText2 = NSAttributedString(string: "\n\(hrs)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 8), NSForegroundColorAttributeName: UIColor.green])
                    attributedMutableText2.append(atrributedText2)
                    
                    self.timeHourDisplayLabel.attributedText = attributedMutableText2
                    
                    let attributedMutableText = NSMutableAttributedString(string: String(minute!), attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)])
                    
                    let atrributedText = NSAttributedString(string: "\n\(mins)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 8), NSForegroundColorAttributeName: UIColor.blue])
                    
                    //
                    attributedMutableText.append(atrributedText)
                    
                    self.timeMinDisplayLabel.attributedText = attributedMutableText
                    
                    
                  
                    let attributedMutableText3 = NSMutableAttributedString(string: String(second!), attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)])
                    
                    let atrributedText3 = NSAttributedString(string: "\n\(secs)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 8), NSForegroundColorAttributeName: UIColor.purple])
                    attributedMutableText3.append(atrributedText3)
                    
                    
                    self.timeSecsDisplayLabel.attributedText = attributedMutableText3
                    
                    
                    
                }
                
                
            }
            
            
        }
        
        
            
        
        

        
    }
    
    

    func deleteContestTime(){
        
        let query = BmobQuery(className: "ContestTime")
        query?.findObjectsInBackground { (results, error) -> Void in
            if error == nil {
                
                
                if (results?.count)! > 0 {
                    
                    for result in results! {
                        
                        let timeObject = result as! BmobObject
                        timeObject.deleteInBackground({ (success, error) in
                            if success{
                                
                                
                            }
                        })
                        
                    }
                    
                }
                
                
                
            }
            
            
        }
    }
    

}
