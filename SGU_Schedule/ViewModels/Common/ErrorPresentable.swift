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

    func showCoreDataError(_ error: Error)
    func showNetworkError(_ error: Error)
    func showUDError(_ error: Error)
    func showBaseError(_ error: Error)
}
