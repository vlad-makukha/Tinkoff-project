//
//  AppDelegate.swift
//  Tinkoff Chat
//
//  Created by Владислав Макуха on 21.09.2021.
//

import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    lazy var animationHandler = AnimationHandler(window: self.window)
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Theme.current.apply()
        FirebaseApp.configure()
        CoreDataStack.shared.didUpdateDataBase = { stack in
            stack.printDatabaseStatistice()
        }
        CoreDataStack.shared.enableObservers()
        
        self.animationHandler.setupTapGesture()
        return true
    }
    
}
