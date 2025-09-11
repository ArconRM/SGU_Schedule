//
//  NotificationManager.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 07.09.2025.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: NSObject, ObservableObject {
    private var groupPersistenceManager: GroupPersistenceManager

    @Published var isPermissionGranted = false
//    @Published var deviceToken: String = ""

    init(groupPersistenceManager: GroupPersistenceManager) {
        self.groupPersistenceManager = groupPersistenceManager

        super.init()

        UNUserNotificationCenter.current().delegate = self
    }

    func requestPermission() {
        UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.apnsToken.rawValue)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                self.isPermissionGranted = granted
                if granted {
                    self.registerForPushNotifications()
                }
            }
        }
    }

    private func registerForPushNotifications() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    func setDeviceToken(_ token: Data) {
        let tokenString = token.map { String(format: "%02.2hhx", $0) }.joined()
//        self.deviceToken = tokenString

        guard UserDefaults.standard.string(forKey: UserDefaultsKeys.apnsToken.rawValue) != nil else {
            sendTokenToServer(tokenString)
            return
        }
    }

    private func sendTokenToServer(_ token: String) {
        guard !token.isEmpty else { return }

        do {
            if let favouriteGroup = try groupPersistenceManager.getFavouriteGroupDTO() {

                let payload: [String: Any] = [
                    "apnsToken": token,
                    "model": UIDevice.current.model,
                    "systemVersion": UIDevice.current.systemVersion,
                    "favouriteGroupDepartment": favouriteGroup.departmentCode,
                    "favouriteGroupNumber": favouriteGroup.fullNumber
                ]

                sendToServer(payload: payload, endpoint: "/api/DeviceManager/RegisterDevice") { success in
                    if success {
                        UserDefaults.standard.set(token, forKey: UserDefaultsKeys.apnsToken.rawValue)
                    }
                }
            }
        } catch let error {
            print(error)
        }
    }

    func updateFavouriteGroup() {
        sendFavouriteGroupUpdate()
    }

    private func sendFavouriteGroupUpdate() {
        guard let token = UserDefaults.standard.string(forKey: UserDefaultsKeys.apnsToken.rawValue) else { return }

        do {
            if let favouriteGroup = try groupPersistenceManager.getFavouriteGroupDTO() {

                let payload: [String: Any] = [
                    "apnsToken": token,
                    "favouriteGroupDepartment": favouriteGroup.departmentCode,
                    "favouriteGroupNumber": favouriteGroup.fullNumber
                ]

                sendToServer(payload: payload, endpoint: "/api/DeviceManager/UpdateFavouriteGroup") { _ in }
            }
        } catch let error {
            print(error)
        }
    }

    private func sendToServer(payload: [String: Any], endpoint: String, completion: ((Bool) -> Void)? = nil) {
        guard let url = URL(string: "\(Config.tokenServerURL)\(endpoint)") else { completion?(false); return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)

            URLSession.shared.dataTask(with: request) { _, _, error in
                if let error = error {
                    print("Server request failed: \(error)")
                    completion?(false)
                } else {
                    completion?(true)
                }
            }.resume()
        } catch {
            print("JSON encoding failed: \(error)")
            completion?(false)
        }
    }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }
}
