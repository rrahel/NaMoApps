//
//  AppDelegate.swift
//  Compass.me
//
//  Created by Cemi Rrahel on 07/11/2017.
//  Copyright © 2017 Cemi Rrahel. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let center = UNUserNotificationCenter.current()
        //ask user for permissions
        center.requestAuthorization(options: [.alert , .sound]){
            (granted , error) in
            if let err = error{
                print("Local Notifications not granted: \(err)")
            }else{
                print("User granted local Notifications :)")
            }
        }
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("delegate called")
        let host = url.host
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if (host != nil) {
            // load the user
            let urlStr = UrlConstants.listUrl + "/" + host!
            if let url = URL(string: urlStr) {
                if let d = try? Data(contentsOf: url) {
                    do {
                        let parsedData = try JSONSerialization.jsonObject(with: d as Data, options: []) as! [String:Any]
                        let user = User(dictionary: parsedData)
                        let nextView = mainStoryboard.instantiateViewController(withIdentifier: "FindFriend") as! FindFriend
                        nextView.user = user
                        self.window?.rootViewController = nextView
                        self.window?.makeKeyAndVisible()
                        return true;
                    }catch let err{
                        print("E: \(err)")
                    }
                }else{
                    print("User could not be loaded")
                }
            }
        }
        
        return false
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

