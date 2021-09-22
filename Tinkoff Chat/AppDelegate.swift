//
//  AppDelegate.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 21.09.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let logFor = Logger()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        logFor.log(message: "Application moved from NOT RUNNING to FOREGROUND INACTIVE")
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication){
        logFor.log(message: "Application moved from FOREGROUND ACTIVE to FOREGROUND INACTIVE")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        logFor.log(message: "Application moved from FOREGROUND INACTIVE to BACKGROUND")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        logFor.log(message: "Application moved from BACKGROUND to FOREGROUND INACTIVE")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        logFor.log(message: "Application moved from FOREGROUND INACTIVE to FOREGROUND ACTIVE")
    }
    
    func applicationWillTerminate(_ application: UIApplication){
        logFor.log(message: "Application moved from SUSPEND to NOT RUNNING")
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

