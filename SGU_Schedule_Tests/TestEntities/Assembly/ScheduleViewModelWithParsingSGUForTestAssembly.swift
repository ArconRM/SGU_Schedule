//
//  ScheduleViewModelWithParsingSGUForTestAssembly.swift
//  SGU_Schedule
//
//  Created by Артемий on 06.02.2024.
//

import Foundation

final class ScheduleViewModelWithParsingSGUForTestAssembly: ScheduleViewModelsAssembly {
    typealias ViewModel = ScheduleViewModelWithParsingSGU
    
    func build() -> ScheduleViewModelWithParsingSGU {
        return ScheduleViewModelWithParsingSGU(lessonsNetworkManager: LessonNetworkManagerForTest(),
                                               sessionEventsNetworkManager: SessionEventsNetworkManagerForTest(),
                                               dateNetworkManager: DateNetworkManagerForTest(),
                                               schedulePersistenceManager: GroupScheduleCoreDataManagerForTest())
    }
}
