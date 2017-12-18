//
//  AppDelegate.swift
//  Trendine
//
//  Created by Rockson on 15/12/2016.
//  Copyright © 2016 RockzAppStudio. All rights reserved.
//

import UIKit
import CoreData
import Contacts
import UserNotifications
import AudioToolbox



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate{

    var window: UIWindow?
    var store = CNContactStore()
    
    
    func checkAccessStatus(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
        case .denied, .notDetermined:
            self.store.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                } else {
                    print("access denied")
                }
            })
        default:
            completionHandler(false)
        }
    }
    
    class func sharedDelegate() -> AppDelegate {
        
        return UIApplication.shared.delegate as! AppDelegate
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        registerForRemoteNotification()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        Bmob.register(withAppKey: "b6240dda812f1eb40b31ddc094f11118")


        if BmobUser.current() == nil {
            
            window?.rootViewController = LoginViewController()
            
    
            
        }else{
            
         
            window?.rootViewController = CustomTabbarController()
            
        
            
        }
        
        
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor = UIColor.white
        
        
        
        return true
    }
    

    func registerForRemoteNotification() {
        
        //this checks if the user is on iOS 10.0
        
        if #available(iOS 10.0, *) {
            
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                    
                    UserDefaults.standard.setValue(true, forKey: "AlertSoundAll")
                    UserDefaults.standard.setValue(true, forKey: "ShowBannerAll")


                }
            }
        }
            
      
    }
    
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        let lowerCase = deviceTokenString.lowercased()
        
        if let currentUser = BmobUser.current() {
            
            let installation = BmobInstallation()
            installation.setDeviceTokenFrom(deviceToken)
            installation.setObject(currentUser, forKey: "user")
            installation.setObject(currentUser.objectId, forKey: "userId")
            installation.saveInBackground(resultBlock: { (success, error) in
                if error == nil{
                    
                    print("installation saved")
                    
                    
                }else{
                    
                    print("error saving install\(error?.localizedDescription as Any)")
                    installation.saveInBackground()
                    
                }
            })
            
        }
     
        
        
        
        
        
        
        if UserDefaults.standard.object(forKey: "deviceTokenString") == nil {
            
            UserDefaults.standard.setValue(lowerCase, forKey: "deviceTokenString")

            
        }else{
            
            UserDefaults.standard.removeObject(forKey: "deviceTokenString")
            UserDefaults.standard.setValue(lowerCase, forKey: "deviceTokenString")
 
            
        }

        
        if UserDefaults.standard.object(forKey: "deviceTokenData") == nil {
            
            UserDefaults.standard.setValue(deviceToken, forKeyPath: "deviceTokenData")
  
            
        }else{
            
            
            UserDefaults.standard.removeObject(forKey: "deviceTokenData")
            UserDefaults.standard.setValue(deviceToken, forKeyPath: "deviceTokenData")
 
            
        }
        

        
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        AudioServicesPlayAlertSound(1110)
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadMessages"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("reloadMessages"), object: nil)

        
        let badgeNumber = UIApplication.shared.applicationIconBadgeNumber
        UIApplication.shared.applicationIconBadgeNumber = badgeNumber + 1
        
        

       
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        UIApplication.shared.applicationIconBadgeNumber = 0

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Trendine")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

