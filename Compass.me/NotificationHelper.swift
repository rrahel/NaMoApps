//
//  NotificationHelper.swift
//  Compass.me
//
//  Created by Kogler Christian on 20.01.18.
//  Copyright © 2018 Cemi Rrahel. All rights reserved.

//  To be used for sending notifications to users. (Not really needed, but implemented because it was required)

import Foundation
import UserNotifications

class NotificationHelper {
    class func sendNotification() {
        print("---send Notification method")
        let content = UNMutableNotificationContent()
        content.title = "Compass.Me"
        content.body = "Thanks for using Compass.Me. Support the developers if you liked it."
        content.sound = UNNotificationSound . default ()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                        repeats: false)
        
        let requestIdentifier = "demoNotification"
        let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
}

