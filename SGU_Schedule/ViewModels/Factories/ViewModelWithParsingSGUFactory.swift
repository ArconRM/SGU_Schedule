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
        return GroupsViewModel(
            groupsNetworkManager: GroupsNetworkManagerWithParsing(
                urlSource: urlSource,
                groupsParser: GroupsHTMLParserSGU(),
                scraper: DynamicScraper()
            ),

            groupPersistenceManager: GroupCoreDataManager()
        )
    }

    public func buildScheduleViewModel() -> ScheduleViewModel {
        return ScheduleViewModel(
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

    public func buildTeacherViewModel() -> TeacherViewModel {
        return TeacherViewModel(
            teacherNetworkManager: TeacherNetworkManagerWithParsing(
                scraper: StaticScraper()
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

    public func buildTeachersSearchViewModel() -> TeachersSearchViewModel {
        return TeachersSearchViewModel(
            teacherNetworkManager: TeacherNetworkManagerWithParsing(scraper: StaticScraper()),
            teacherSearchResultsUDManager: TeacherSearchResultsUDManager()
        )
    }
}
