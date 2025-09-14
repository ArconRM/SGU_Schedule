//
//  AppDelegate.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 07.09.2025.
//

import Foundation
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    var notificationManager: NotificationManager?

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // This is called by iOS when device successfully registers for push notifications
        do {
            try notificationManager?.setDeviceToken(deviceToken)
        } catch let error {
            print("Failed to set device token: \(error)")
        }
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // This is called if registration fails
        print("Failed to register for remote notifications: \(error)")
        // You might want to show an alert to the user here
    }
}
