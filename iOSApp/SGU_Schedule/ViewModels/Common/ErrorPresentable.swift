//
//  ErrorPresentable.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 26.01.2025.
//

import Foundation
import SwiftUI

protocol ErrorPresentable {
    var isShowingError: Bool { get set }
    var activeError: LocalizedError? { get set }

    func showError(_ error: Error)
}
