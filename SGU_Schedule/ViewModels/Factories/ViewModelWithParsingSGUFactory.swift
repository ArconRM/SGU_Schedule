//
//  ViewModelWithParsingSGUFactory.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 31.05.2024.
//

import Foundation

public final class ViewModelWithParsingSGUFactory: ViewModelFactory {
    public func buildDepartmentsViewModel() -> DepartmentsViewModel {
        return DepartmentsViewModel()
    }
    
    public func buildGroupsViewModel(department: DepartmentDTO) -> GroupsViewModel {
        return GroupsViewModel (
            department: department,
            
            networkManager: GroupsNetworkManagerWithParsing(
                urlSource: URLSourceSGU_old(),
                groupsParser: GroupsHTMLParserSGU_old()
            )
        )
    }
    
    public func buildScheduleViewModel(department: DepartmentDTO) -> ScheduleViewModel {
        return ScheduleViewModel (
            department: department,
            
            lessonsNetworkManager: LessonNetworkManagerWithParsing(
                urlSource: URLSourceSGU_old(),
                lessonParser: LessonHTMLParserSGU_old()
            ),
            
            sessionEventsNetworkManager: SessionEventsNetworkManagerWithParsing(
                urlSource: URLSourceSGU_old(),
                sessionEventsParser: SessionEventsHTMLParserSGU_old()
            ),
            
            dateNetworkManager: DateNetworkManagerWithParsing(
                urlSource: URLSourceSGU_old(),
                dateParser: DateHTMLParserSGU_old()
            ),
            
            schedulePersistenceManager: GroupScheduleCoreDataManager()
        )
    }
    
    public func buildTeacherInfoViewModel() -> TeacherInfoViewModel {
        return TeacherInfoViewModel (
            teacherNetworkManager: TeacherNetworkManagerWithParsing(
                urlSource: URLSourceSGU_old(),
                teacherParser: TeacherHTMLParserSGU_old()
            ),
            
            lessonsNetworkManager: LessonNetworkManagerWithParsing(
                urlSource: URLSourceSGU_old(),
                lessonParser: LessonHTMLParserSGU_old()
            ),
            
            sessionEventsNetworkManager: SessionEventsNetworkManagerWithParsing(
                urlSource: URLSourceSGU_old(),
                sessionEventsParser: SessionEventsHTMLParserSGU_old()
            )
        )
    }
}
