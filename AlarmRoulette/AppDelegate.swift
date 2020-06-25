//
//  AppDelegate.swift
//  AlarmRoulette
//
//  Created by Joshua Segal on 6/6/20.
//  Copyright © 2020 Joshua Segal. All rights reserved.
//

import UIKit
import Firebase
import SwiftUI


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    //    var sharedHomeView = HomeView.sharedHomeView
    var alarmGlobal = AlarmGlobal()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        FirebaseApp.configure()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

//MARK: - Enabling alarm notfications in Foreground + Action for Notification Response
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("notification was tapped")
        //        sharedHomeView.tapNot()
        withAnimation(.easeInOut(duration: 0.2)) {
            alarmGlobal.HomeView = "alarmPopUp"
        }
        //        print("sharedHomeView: \(sharedHomeView)")
        print(response)
        //        print(response.notification.request.content.userInfo["alarmid"]!)
//        alarmGlobal.notification_ids = response.notification.request.content.userInfo["notification_ids"] as! [String]
        alarmGlobal.alarmid = response.notification.request.content.userInfo["alarmid"] as! String
//        print(alarmGlobal.notification_ids)
        print(alarmGlobal.alarmid)
        completionHandler()
    }
}
