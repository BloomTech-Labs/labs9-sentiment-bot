//
//  LocalNotificationHelper.swift
//  Sentiment Bot
//
//  Created by Moin Uddin on 1/11/19.
//  Copyright © 2019 Scott Bennett. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationHelper: NSObject, UNUserNotificationCenterDelegate {
    
    
    override init() {
        super.init()
        let center = UNUserNotificationCenter.current()
        center.delegate = self
    }
    
    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if let error = error { NSLog("Error requesting authorization status for local notifications: \(error)") }
            
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //This is called right before the notifcation gets shown to the user.
        //Calling this will show the alert in the app.
        completionHandler([.alert, .sound])
    }
    
    //Repond to selected emoji from survey
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response.actionIdentifier)
        
        completionHandler()
    }
    
    func sendSurveyNotification(emojis: [String], schedule: String) {
        let emojiActions = emojis.map({UNNotificationAction(identifier: $0, title: $0, options: [])})
        
        let category = UNNotificationCategory(identifier: "emojiCategory", actions: emojiActions, intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        let content = UNMutableNotificationContent()
        content.title = "How do you feel?"
        //content.sound = UNNotificationSound.default
        content.categoryIdentifier = "emojiCategory"
        
        
        let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: Date())
        let triggerDaily = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        let triggerMonthly = Calendar.current.dateComponents([.day], from: Date())
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
        
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "NotificationID", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) {error in
            if let error = error {
                NSLog("There was an error scheduling a notification: \(error)")
                return
            }
            
        }
        
    }
}
