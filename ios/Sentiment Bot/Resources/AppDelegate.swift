//
//  AppDelegate.swift
//  Sentiment Bot
//
//  Created by Scott Bennett on 1/8/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import UIKit
import GoogleSignIn
import UserNotifications

enum Identifiers {
    static let viewAction = "VIEW_IDENTIFIER"
    static let feelz = "FEELZ"
}

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {
    
    var window: UIWindow?

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //LocalNotificationHelper.shared.removePendingNotifications()
        NSLog(LocalNotificationHelper.shared.nextTriggerDate())
        GIDSignIn.sharedInstance()?.clientID = "803137383645-5pp4mgm804lbaeaur9p9en70usos2qrm.apps.googleusercontent.com"
        
        // Push Notification Code
        registerForPushNotifications()
        let notificationOption = launchOptions?[.remoteNotification]
        if let notification = notificationOption as? [String: AnyObject], let aps = notification["aps"] as? [String: AnyObject] {
            NSLog("Message Received: \(aps)")
            (window?.rootViewController as? UITabBarController)?.selectedIndex = 3
        }
        
        // UIAppearance
        Theme.current.apply()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        //APIController.shared.logout()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //APIController.shared.logout()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //APIController.shared.logout()
    }
    
    // Lets tabBarController present a tab modally
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        if viewController is ProfileViewController {
//            if let newVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") {
//                newVC.modalPresentationStyle = .overFullScreen
//                tabBarController.present(newVC, animated: true)
//                return false
//            }
//        }
//        return true
//    }
}

// MARK: - Push Notifications

extension AppDelegate {
    
    // Registers for Push Notifications
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            NSLog("Permission granted: \(granted)")
            guard granted else { return }
            
            self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            NSLog("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%2.2hhx", data) }
        let deviceToken = tokenParts.joined()
        UserDefaults.standard.set(deviceToken, forKey: UserDefaultsKeys.deviceToken.rawValue)
        NSLog("Device Token: \(deviceToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("Failed to register: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Did Receive Notifcation is triggered")
        guard let aps = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        
        let state: UIApplication.State = application.applicationState
        
        switch state {
        case UIApplication.State.active:
            print("active")
        default:
            print("default")
            
        }
        
        
        let time = userInfo["time"] as! String
        //Schedule
        let schedule = userInfo["schedule"] as! String
        let surveyId = userInfo["surveyId"] as! Int
        guard let feelingsDictionaryArray = userInfo["feelings"] as? [[String: Any]] else {
            NSLog("There's a problem retreving feelings from server for push notification")
            return
        }
        
        LocalNotificationHelper.shared.sendSurveyNotification(feelingsDictionaryArray: feelingsDictionaryArray, schedule: schedule, surveyId: surveyId, time: time)

        NSLog("Message Received: \(aps)")
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("This is triggered")
        completionHandler([.sound])
    }
}



extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification Received")
        let userInfo = response.notification.request.content.userInfo
        
        if let aps = userInfo["aps"] as? [String: AnyObject] {
            
            NSLog("aps: \(aps)")
            (window?.rootViewController as? UITabBarController)?.selectedIndex = 2
            
            if response.actionIdentifier == Identifiers.viewAction {
                
                NSLog("View Selected")
                (window?.rootViewController as? UITabBarController)?.selectedIndex = 2
            }
        }
        completionHandler()
    }
}

