//
//  NotificationManager.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 07.09.2025.
//

import Foundation
import UserNotifications
import SwiftUI
import OSLog

class NotificationManager: NSObject, ObservableObject {
    private let logger = Logger()

    private var groupPersistenceManager: GroupPersistenceManager

    @Published var isPermissionGranted = false

    init(groupPersistenceManager: GroupPersistenceManager) {
        self.groupPersistenceManager = groupPersistenceManager

        super.init()

        UNUserNotificationCenter.current().delegate = self
    }

    func requestPermission() {
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

    func setDeviceToken(_ token: Data) throws {
        let tokenString = token.map { String(format: "%02.2hhx", $0) }.joined()
        let savedToken = UserDefaults.standard.string(forKey: UserDefaultsKeys.apnsToken.rawValue)

        if savedToken == nil || savedToken != tokenString {
            UserDefaults.standard.set(tokenString, forKey: UserDefaultsKeys.apnsToken.rawValue)
            try sendTokenToServer(tokenString)
        }
    }

    func registerDevice() throws {
        guard let token = UserDefaults.standard.string(forKey: UserDefaultsKeys.apnsToken.rawValue) else { return }

        if !UserDefaults.standard.bool(forKey: UserDefaultsKeys.isRegisteredForNotifications.rawValue) {
            try sendTokenToServer(token)
        }
    }

    private func sendTokenToServer(_ token: String) throws {
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

                sendToServer(endpoint: "/api/DeviceManager/RegisterDevice", payload: payload) { result in
                    if result {
                        UserDefaults.standard.set(token, forKey: UserDefaultsKeys.apnsToken.rawValue)
                        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isRegisteredForNotifications.rawValue)
                    } else {
                        self.logger.error("Failed to register device with \(token)")
                    }
                }
            }
        } catch let error {
            throw NetworkError.notificationManagerError
        }
    }

    func updateFavouriteGroup() throws {
        try sendFavouriteGroupUpdate()
    }

    private func sendFavouriteGroupUpdate() throws {
        guard let token = UserDefaults.standard.string(forKey: UserDefaultsKeys.apnsToken.rawValue) else { return }

        do {
            if let favouriteGroup = try groupPersistenceManager.getFavouriteGroupDTO() {

                let payload: [String: Any] = [
                    "apnsToken": token,
                    "favouriteGroupDepartment": favouriteGroup.departmentCode,
                    "favouriteGroupNumber": favouriteGroup.fullNumber
                ]

                sendToServer(endpoint: "/api/DeviceManager/UpdateFavouriteGroup", payload: payload) { result in
                    if !result {
                        self.logger.error("Failed to update favourite group with \(result)")
                    }
                }
            }
        } catch let error {
            throw NetworkError.notificationManagerError
        }
    }

    func unregisterDeviceFromNotiticationServer() throws {
        try sendUnregisterDevice()
    }

    private func sendUnregisterDevice() throws {
        guard let token = UserDefaults.standard.string(forKey: UserDefaultsKeys.apnsToken.rawValue) else { return }

        do {
            sendToServer(endpoint: "/api/DeviceManager/UnregisterDevice", queryItems: [
                URLQueryItem(name: "apnsToken", value: token)
            ]) { result in
                if result {
                    UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isRegisteredForNotifications.rawValue)
                } else {
                    self.logger.error("Failed to unregister device with \(result)")
                }
            }
        } catch let error {
            throw NetworkError.notificationManagerError
        }
    }

    private func sendToServer(
        endpoint: String,
        queryItems: [URLQueryItem]? = nil,
        payload: [String: Any]? = nil,
        completion: ((Bool) -> Void)? = nil
    ) {
        var components = URLComponents(string: "\(Config.tokenServerURL)\(endpoint)")
        components?.queryItems = queryItems

        guard let url = components?.url else { completion?(false); return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let payload = payload {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: payload)
            } catch {
                print("JSON encoding failed: \(error)")
                completion?(false)
                return
            }
        }

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Server request failed: \(error)")
                completion?(false)
            } else {
                completion?(true)
            }
        }.resume()
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
