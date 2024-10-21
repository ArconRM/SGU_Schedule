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
    
    public func buildGroupsViewModel(department: Department) -> GroupsViewModel {
        return GroupsViewModel (
            networkManager: GroupsNetworkManagerWithParsing(
                urlSource: urlSource,
                groupsParser: GroupsHTMLParserSGU(),
                scraper: DynamicScraper()
            ), 
            
            groupPersistenceManager: GroupCoreDataManager()
        )
    }
    
    public func buildScheduleViewModel() -> ScheduleViewModel {
        return ScheduleViewModel (
            lessonsNetworkManager: LessonNetworkManagerWithParsing(
                urlSource: urlSource,
                lessonParser: LessonHTMLParserSGU(),
                scraper: StaticScraper()
            ),
            
            sessionEventsNetworkManager: SessionEventsNetworkManagerWithParsing(
                urlSource: urlSource,
                sessionEventsParser: SessionEventsHTMLParserSGU(),
                scraper: DynamicScraper()
            ),
            
            schedulePersistenceManager: GroupScheduleCoreDataManager(),
            
            lessonSubgroupsPersistenceManager: LessonSubgroupsUDManager()
        )
    }
    
    public func buildTeacherInfoViewModel() -> TeacherInfoViewModel {
        return TeacherInfoViewModel (
            teacherNetworkManager: TeacherNetworkManagerWithParsing(
                urlSource: urlSource,
                teacherParser: TeacherHTMLParserSGU_old()
            ),
            
            lessonsNetworkManager: LessonNetworkManagerWithParsing(
                urlSource: urlSource,
                lessonParser: LessonHTMLParserSGU(),
                scraper: StaticScraper()
            ),
            
            sessionEventsNetworkManager: SessionEventsNetworkManagerWithParsing(
                urlSource: urlSource,
                sessionEventsParser: SessionEventsHTMLParserSGU(),
                scraper: DynamicScraper()
            )
        )
    }
}
