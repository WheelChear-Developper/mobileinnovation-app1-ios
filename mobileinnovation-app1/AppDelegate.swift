//
//  AppDelegate.swift
//  mobileinnovation-app1
//
//  Created by M.Amatani on 2017/08/11.
//  Copyright © 2017年 Mobile Innovation. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    // appDelegateの UIApplicationインスタンス保存用
    var appApplication: UIApplication?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //ナビゲーションアイテムの色を変更
        UINavigationBar.appearance().tintColor = UIColor.white
        //ナビゲーションバーの背景を変更
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.2549019608, green: 0.3490196078, blue: 0.5411764706, alpha: 1)
        //ナビゲーションのタイトル文字列の色を変更
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]

        // 通知用ライブラリのインスタンス
        let notification_lib = Notification_lib()
        notification_lib.setNotificationCount(count: 0)

        // appDelegateの UIApplicationインスタンス保存
        appApplication = application

        return true
    }

    func setNotification() {

        // APNs
        if #available(iOS 10, *) {
            // For iOS 10
            UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .sound, .badge]) { (granted: Bool, error: Error?) in
                if (error != nil) {
                    print("Failed to request authorization.")
                    return
                }
                if granted {
                    self.appApplication?.registerForRemoteNotifications()
                } else {
                    print("The user refused the push notification.")
                }
            }
        } else {
            // For iOS 8/iOS 9
            let notificationSettings = UIUserNotificationSettings(types: [.alert, .sound, .badge], categories: nil)
            self.appApplication?.registerUserNotificationSettings(notificationSettings)
            self.appApplication?.registerForRemoteNotifications()
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let token = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
        print("DeviceToken : " + token)

        let config_instance = Configuration()
        config_instance.configurationSet_String(value: token, keyName: "DeviceToken")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

        print("Failed to register to APNs: \(error)")
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

