//
//  GroupSessionEventsFetchResult.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 18.04.2025.
//

import Foundation
import SguParser

struct GroupSessionEventsFetchResult {
    var sessionEvents: GroupSessionEventsDTO?
    var loadedWithChanges: Bool
}
