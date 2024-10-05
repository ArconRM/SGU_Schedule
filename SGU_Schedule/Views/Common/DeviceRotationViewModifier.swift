//
//  DeviceRotationViewModifier.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 04.10.2024.
//

import Foundation
import SwiftUI

//https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-device-rotation xd
struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}
