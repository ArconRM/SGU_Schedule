//
//  SessionEventsFetchResult.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 08.01.2025.
//

import Foundation
import SguParser

enum SessionEventsFetchResult {
    case unknownErrorWhileFetching(error: Error? = nil)
    case noFavoriteGroup
    case success(consultation: SessionEventDTO?, exam: SessionEventDTO?)

    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }

    var consultation: SessionEventDTO? {
        switch self {
        case .success(consultation: let consultation, exam: _):
            return consultation
        default:
            return nil
        }
    }

    var exam: SessionEventDTO? {
        switch self {
        case .success(consultation: _, exam: let exam):
            return exam
        default:
            return nil
        }
    }
}
