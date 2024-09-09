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
    
    public func buildGroupsViewModel(department: DepartmentDTO) -> GroupsViewModel {
        return GroupsViewModel (
            department: department,
            
            networkManager: GroupsNetworkManagerWithParsing(
                urlSource: urlSource,
                groupsParser: GroupsHTMLParserSGU_old(),
                scraper: StaticScraper()
            ), 
            
            groupPersistenceManager: GroupCoreDataManager()
        )
    }
    
    public func buildScheduleViewModel(selectedDepartmentCode: String) -> ScheduleViewModel {
        return ScheduleViewModel (
            selectedDepartmentCode: selectedDepartmentCode,
            
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
            
            schedulePersistenceManager: GroupScheduleCoreDataManager()
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
