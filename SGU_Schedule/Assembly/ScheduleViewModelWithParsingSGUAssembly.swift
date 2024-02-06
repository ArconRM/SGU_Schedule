//
//  ScheduleViewModelWithParsingSGUAssembly.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

//TODO: мб стоит сюда инжектировать все парсеры, но блинб тогда без интерфейса самого ассемблая
class ScheduleViewModelWithParsingSGUAssembly: ScheduleViewModelsAssembly {
    typealias ViewModel = ScheduleViewModelWithParsingSGU

    func build() -> ViewModel {
        return ScheduleViewModelWithParsingSGU (
            lessonsNetworkManager: LessonNetworkManagerWithParsing(urlSource: URLSourceSGU(),
                                                                    lessonParser: LessonHTMLParserSGU()),
            
            sessionEventsNetworkManager: SessionEventsNetworkManagerWithParsing(urlSource: URLSourceSGU(),
                                                                                sessionEventsParser: SessionEventsHTMLParserSGU()),
            
            dateNetworkManager: DateNetworkManagerWithParsing(urlSource: URLSourceSGU(),
                                                              dateParser: DateHTMLParserSGU()),
            
            schedulePersistenceManager: GroupScheduleCoreDataManager()
        )
    }
}
