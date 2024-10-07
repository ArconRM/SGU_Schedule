//
//  UIScreenExtension.swift
//  SGU_Schedule
//
//  Created by Артемий on 25.10.2023.
//

import Foundation
import SwiftUI

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
    
    static func getModalViewMaxPadding(initialOrientation: UIDeviceOrientation, currentOrientation: UIDeviceOrientation) -> CGFloat {
        if UIDevice.isPhone {
            return self.screenHeight * 0.6
        } else if initialOrientation.isLandscape {
            return currentOrientation.isLandscape ?
            self.screenHeight * 0.6 :
            self.screenWidth * 0.6
        } else {
            return currentOrientation.isPortrait ?
            self.screenHeight * 0.6 :
            self.screenWidth * 0.6
        }
        
    }
}

// С горизонтального w1180 и h820
// С вертикального w820 и h1180

/// Должно быть:
///в горизонтальном 820 * 0.6
///в вертикальном 1180 * 0.6
