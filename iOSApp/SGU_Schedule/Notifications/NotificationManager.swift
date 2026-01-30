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

    // Единая точка входа для запроса разрешений и регистрации
    func requestPermissionIfNeeded() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .authorized:
                    // Разрешение уже есть - регистрируемся
                    self.isPermissionGranted = true
                    UIApplication.shared.registerForRemoteNotifications()

                case .notDetermined:
                    // Первый раз - запрашиваем разрешение
                    self.requestPermission()

                case .denied, .provisional, .ephemeral:
                    self.isPermissionGranted = false

                @unknown default:
                    break
                }
            }
        }
    }

    private func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, error in
            DispatchQueue.main.async {
                self.isPermissionGranted = granted
                if granted {
                    UIApplication.shared.registerForRemoteNotifications()
                } else if let error = error {
                    self.logger.error("Permission denied: \(error.localizedDescription)")
                }
            }
        }
    }

    // Вызывается из AppDelegate
    func didReceiveDeviceToken(_ token: Data) {
        let tokenString = token.map { String(format: "%02.2hhx", $0) }.joined()
        logger.info("Received device token: \(tokenString)")

        let savedToken = UserDefaults.standard.string(forKey: UserDefaultsKeys.apnsToken.rawValue)
        let needToSend = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isRegisteredForNotifications.rawValue)

        // Проверяем, нужно ли отправлять на сервер
        if needToSend && shouldSendTokenToServer(newToken: tokenString, savedToken: savedToken) {
            UserDefaults.standard.set(tokenString, forKey: UserDefaultsKeys.apnsToken.rawValue)
            sendTokenToServer(tokenString)
        }
    }

    private func shouldSendTokenToServer(newToken: String, savedToken: String?) -> Bool {
        // Токен изменился
        if savedToken != newToken {
            logger.info("Token changed, will send to server")
            return true
        }

        // Проверяем давность последнего обновления
        if let lastUpdate = UserDefaults.standard.object(
            forKey: UserDefaultsKeys.lastTokenUpdateDate.rawValue
        ) as? Date {
            let daysSinceUpdate = Calendar.current.dateComponents(
                [.day], from: lastUpdate, to: Date()
            ).day ?? 0

            if daysSinceUpdate >= 10 {
                logger.info("Token older than 10 days, will refresh")
                return true
            }
        } else {
            // Нет информации о последнем обновлении
            logger.info("No update date, will send to server")
            return true
        }

        logger.info("Token is up to date, skipping server update")
        return false
    }

    private func sendTokenToServer(_ token: String) {
        guard !token.isEmpty else { return }

        do {
            try sendUnregisterDevice()

            guard let favouriteGroup = try groupPersistenceManager.getFavouriteGroupDTO() else {
                logger.warning("No favourite group, skipping token registration")
                return
            }

            let payload: [String: Any] = [
                "apnsToken": token,
                "model": UIDevice.current.model,
                "systemVersion": UIDevice.current.systemVersion,
                "favouriteGroupDepartment": favouriteGroup.departmentCode,
                "favouriteGroupNumber": favouriteGroup.fullNumber,
                "registeredAt": Int64(Date().timeIntervalSince1970 * 1000)
            ]

            sendToServer(endpoint: "/api/DeviceManager/RegisterDevice", payload: payload) { result in
                if result {
                    UserDefaults.standard.set(token, forKey: UserDefaultsKeys.apnsToken.rawValue)
                    UserDefaults.standard.set(Date(), forKey: UserDefaultsKeys.lastTokenUpdateDate.rawValue)
                    self.logger.info("Token successfully registered on server")
                } else {
                    self.logger.error("Failed to register token on server")
                }
            }
        } catch {
            logger.error("Failed to send token: \(error.localizedDescription)")
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
                    if result {
                        self.logger.info("Token successfully unregistered on server")
                    } else {
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
                    UserDefaults.standard.set(nil, forKey: UserDefaultsKeys.apnsToken.rawValue)
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
