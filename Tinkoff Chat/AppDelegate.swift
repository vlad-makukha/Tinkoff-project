//
//  AppDelegate.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 21.09.2021.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let logFor = Logger()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        logFor.log(message: "Application moved from NOT RUNNING to FOREGROUND INACTIVE")
        Theme.current.apply()
        FirebaseApp.configure()
        CoreDataStack.coreDataStack.didUpdateDataBase = { stack in
            stack.printDatabaseStatistice()
        }
        CoreDataStack.coreDataStack.enableObservers()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
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

    func applicationWillTerminate(_ application: UIApplication) {
        logFor.log(message: "Application moved to NOT RUNNING")
    }

}
