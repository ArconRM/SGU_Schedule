//
//  UIDeviceExtension.swift
//  SGU_Schedule
//
//  Created by Артемий on 06.02.2024.
//

import Foundation
import SwiftUI

extension UIDevice {
    static var isPad: Bool {
        self.current.userInterfaceIdiom == .pad
    }

    static var isPhone: Bool {
        self.current.userInterfaceIdiom == .phone
    }

    static var isLandscape: Bool {
        self.current.orientation == .landscapeLeft || self.current.orientation == .landscapeRight
    }

    static var isPortrait: Bool {
        self.current.orientation == .portrait || self.current.orientation == .portraitUpsideDown
    }
}
