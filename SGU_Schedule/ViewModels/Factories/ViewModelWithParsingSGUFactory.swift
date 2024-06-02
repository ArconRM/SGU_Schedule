//
//  ViewModelWithParsingSGUFactory.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 31.05.2024.
//

import Foundation

public final class ViewModelWithParsingSGUFactory: ViewModelFactory {
    
    public func buildScheduleViewModel() -> ScheduleViewModel {
        return ScheduleViewModel (
            lessonsNetworkManager: LessonNetworkManagerWithParsing(urlSource: URLSourceSGU_old(),
                                                                   lessonParser: LessonHTMLParserSGU()),
            
            sessionEventsNetworkManager: SessionEventsNetworkManagerWithParsing(urlSource: URLSourceSGU_old(),
                                                                                sessionEventsParser: SessionEventsHTMLParserSGU()),
            
            dateNetworkManager: DateNetworkManagerWithParsing(urlSource: URLSourceSGU_old(),
                                                              dateParser: DateHTMLParserSGU()),
            
            schedulePersistenceManager: GroupScheduleCoreDataManager()
        )
    }
    
    public func buildGroupsViewModel() -> GroupsViewModel {
        return GroupsViewModel (
            networkManager: GroupsNetworkManagerWithParsing(urlSource: URLSourceSGU_old(),
                                                            groupsParser: GroupsHTMLParserSGU())
        )
    }
    
    public func buildTeacherInfoViewModel() -> TeacherInfoViewModel {
        return TeacherInfoViewModel (
            teacherNetworkManager: TeacherNetworkManagerWithParsing(urlSource: URLSourceSGU_old(),
                                                                    teacherParser: TeacherHTMLParserSGU()),
            
            lessonsNetworkManager: LessonNetworkManagerWithParsing(urlSource: URLSourceSGU_old(),
                                                                   lessonParser: LessonHTMLParserSGU()),
            
            sessionEventsNetworkManager: SessionEventsNetworkManagerWithParsing(urlSource: URLSourceSGU_old(),
                                                                                sessionEventsParser: SessionEventsHTMLParserSGU())
        )
    }
}
