//
//  AppDelegate.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 07.09.2025.
//

import Foundation
import SwiftUI
class AppDelegate: NSObject, UIApplicationDelegate {
    weak var notificationManager: NotificationManager?  // ← weak!

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        print("AppDelegate received token")
        notificationManager?.didReceiveDeviceToken(deviceToken)
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("APNS registration failed: \(error)")
    }
}
