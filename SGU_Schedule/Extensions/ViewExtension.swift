//
//  ViewExtension.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 04.10.2024.
//

import Foundation
import SwiftUI

// https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-device-rotation xd x2
extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}
