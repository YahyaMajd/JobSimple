//
//  IOSAppApp.swift
//  IOSApp
//
//  Created by Yahya on 2024-09-08.
//

import SwiftUI
import Firebase
@main
struct IOSAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Firebase Configured")
        return true
    }
}
