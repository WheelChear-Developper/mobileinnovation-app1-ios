//
//  Notification_lib.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/16.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import UIKit
import UserNotifications

class Notification_lib: NSObject {

    // 通知許可確認
    class var isPushNotificationEnable: Bool {

        let status = UIApplication.shared.currentUserNotificationSettings?.types
        if let status = status {
            if status.contains(UIUserNotificationType.badge) {
                print("Badge ON")
                return true
            }else if status.contains(UIUserNotificationType.sound) {
                print("Sound ON")
                return true
            }else if status.contains(UIUserNotificationType.alert) {
                print("Alert ON")
                return true
            }else{
                print("Badge OFF")
                return false
            }
        }else{
            print("Badge OFF")
            return false
        }
    }

    func setNotification() {

        if #available(iOS 10.0, *) {
            // iOS 10以降
            UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound, .badge]) { (granted: Bool, error: Error?) in
                if (error != nil) {
                    print("Failed to request authorization.")
                }
                if granted {
                    //UIApplication.registerForRemoteNotifications()
                } else {
                    print("The user refused the push notification.")
                }
            }
        } else {
            // iOS 9以下
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }

    func setNotificationCount(count: Int) {

        UIApplication.shared.applicationIconBadgeNumber = count
    }

    func setNotificationAleart(titleMessage: String, subTitleMessage: String, bodyMessage: String, bageNo: Double, secondTime: Double) {

        if #available(iOS 10.0, *) {
            let notification = UNMutableNotificationContent()
            notification.title = titleMessage
            notification.subtitle = subTitleMessage
            notification.body = bodyMessage
            notification.badge = NSNumber(value: bageNo)
            notification.sound = UNNotificationSound.default()
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: secondTime, repeats: false)
            let request = UNNotificationRequest(identifier: "Identifier", content: notification, trigger: trigger)
            let center = UNUserNotificationCenter.current()
            center.add(request)
        } else {
            let notification = UILocalNotification()
            notification.alertAction = "アプリを開く"
            notification.alertBody = bodyMessage
            notification.fireDate = NSDate(timeIntervalSinceNow: secondTime) as Date
            notification.soundName = UILocalNotificationDefaultSoundName
            notification.applicationIconBadgeNumber = Int(bageNo)
            notification.userInfo = ["notifyID":""]
            UIApplication.shared.scheduleLocalNotification(notification)
        }
    }
    // テストローカル通知
    //        notification_lib.setNotificationAleart(titleMessage: "title", subTitleMessage: "subtitle", bodyMessage: "body", bageNo: 33, secondTime: 10)
}
