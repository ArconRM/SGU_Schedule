//
//  ViewModelWithParsingSGUFactory.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 31.05.2024.
//

import Foundation

public final class ViewModelWithParsingSGUFactory: ViewModelFactory {
    private var urlSource = URLSourceSGU()
    
    public func buildDepartmentsViewModel() -> DepartmentsViewModel {
        return DepartmentsViewModel()
    }
    
    public func buildGroupsViewModel(department: DepartmentDTO) -> GroupsViewModel {
        return GroupsViewModel (
            department: department,
            
            networkManager: GroupsNetworkManagerWithParsing(
                urlSource: urlSource,
                groupsParser: GroupsHTMLParserSGU()
            )
        )
    }
    
    public func buildScheduleViewModel(department: DepartmentDTO) -> ScheduleViewModel {
        return ScheduleViewModel (
            department: department,
            
            lessonsNetworkManager: LessonNetworkManagerWithParsing(
                urlSource: urlSource,
                lessonParser: LessonHTMLParserSGU()
            ),
            
            sessionEventsNetworkManager: SessionEventsNetworkManagerWithParsing(
                urlSource: urlSource,
                sessionEventsParser: SessionEventsHTMLParserSGU()
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
                urlSource: urlSource,
                lessonParser: LessonHTMLParserSGU()
            ),
            
            sessionEventsNetworkManager: SessionEventsNetworkManagerWithParsing(
                urlSource: urlSource,
                sessionEventsParser: SessionEventsHTMLParserSGU()
            )
        )
    }
}
