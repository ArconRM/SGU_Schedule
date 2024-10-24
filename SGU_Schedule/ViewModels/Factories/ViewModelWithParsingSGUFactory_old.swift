//
//  ViewModelWithParsingSGUFactory_old.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 06.09.2024.
//

import Foundation

public final class ViewModelWithParsingSGUFactory_old: ViewModelFactory {
    private var urlSource = URLSourceSGU_old()
    
    public func buildDepartmentsViewModel() -> DepartmentsViewModel {
        return DepartmentsViewModel()
    }
    
    public func buildGroupsViewModel(department: Department) -> GroupsViewModel {
        return GroupsViewModel (
            networkManager: GroupsNetworkManagerWithParsing(
                urlSource: urlSource,
                groupsParser: GroupsHTMLParserSGU_old(),
                scraper: StaticScraper()
            ), 
            
            groupPersistenceManager: GroupCoreDataManager()
        )
    }
    
    public func buildScheduleViewModel() -> ScheduleViewModel {
        return ScheduleViewModel (
            lessonsNetworkManager: LessonNetworkManagerWithParsing(
                urlSource: urlSource,
                lessonParser: LessonHTMLParserSGU_old(),
                scraper: StaticScraper()
            ),
            
            sessionEventsNetworkManager: SessionEventsNetworkManagerWithParsing(
                urlSource: urlSource,
                sessionEventsParser: SessionEventsHTMLParserSGU_old(),
                scraper: StaticScraper()
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
                lessonParser: LessonHTMLParserSGU_old(),
                scraper: StaticScraper()
            ),
            
            sessionEventsNetworkManager: SessionEventsNetworkManagerWithParsing(
                urlSource: urlSource,
                sessionEventsParser: SessionEventsHTMLParserSGU(),
                scraper: StaticScraper()
            )
        )
    }
}
