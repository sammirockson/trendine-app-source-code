//
//  CustomTabbarController.swift
//  Trendin
//
//  Created by Rockson on 7/17/16.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit

class CustomTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trendingVC = TrendinCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let trendingNav = UINavigationController(rootViewController: trendingVC)
        trendingVC.tabBarItem.image = UIImage(named: "trending")
        trendingVC.tabBarItem.selectedImage = UIImage(named: "trendingSelected")
        trendingVC.tabBarItem.title = "Trending"
        trendingVC.tabBarItem.tag = 1
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let chatVC = ChatCollectionViewController(collectionViewLayout: layout )
        let chatNav = UINavigationController(rootViewController: chatVC)
        chatVC.tabBarItem.title = "Chats"
        chatVC.tabBarItem.image = UIImage(named: "chatIcon")
        chatVC.tabBarItem.selectedImage = UIImage(named: "chatIconSelected")
        chatVC.tabBarItem.tag = 2
        
        
        

        let Contacts = ContactTableViewController()
        let followersNav = UINavigationController(rootViewController: Contacts)
        Contacts.tabBarItem.title = "Friends"
        Contacts.tabBarItem.image = UIImage(named: "followers")
        Contacts.tabBarItem.selectedImage = UIImage(named: "followersSelected")
        Contacts.tabBarItem.tag = 3


        let notiLayout = UICollectionViewFlowLayout()
        notiLayout.minimumLineSpacing = 0
        let notificationVC = NotificationCenterCollectionViewController(collectionViewLayout: notiLayout)
        notificationVC.tabBarItem.image = UIImage(named: "notificationsUnselected")
        notificationVC.tabBarItem.selectedImage = UIImage(named: "notificationSelected")
        notificationVC.tabBarItem.title = "Notifications"
        notificationVC.tabBarItem.tag = 4
        let notificationNav = UINavigationController(rootViewController: notificationVC)

        
        
        let settingVC = SettingsTableViewController(style: UITableViewStyle.grouped)
        let settingNav = UINavigationController(rootViewController: settingVC)
        settingVC.tabBarItem.title = "More"
        settingVC.tabBarItem.image = #imageLiteral(resourceName: "MoreUnselected")
        settingVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "MoreSelected")
        settingVC.tabBarItem.tag = 5
 
        self.viewControllers = [trendingNav, chatNav , followersNav ,notificationNav, settingNav]

    }


}
