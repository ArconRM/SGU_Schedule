//
//  SafeAreaInsets.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 20.09.2025.
//

import Foundation
import SwiftUI

internal struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).insets
    }
}

extension EnvironmentValues {

    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

internal extension UIEdgeInsets {

    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: 0, trailing: right)
    }
}
