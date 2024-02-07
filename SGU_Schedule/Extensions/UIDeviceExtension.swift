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
}
