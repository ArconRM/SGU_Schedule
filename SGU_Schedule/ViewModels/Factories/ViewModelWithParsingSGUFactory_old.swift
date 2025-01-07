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
        return GroupsViewModel(
            groupsNetworkManager: GroupsNetworkManagerWithParsing(
                urlSource: urlSource,
                groupsParser: GroupsHTMLParserSGU_old(),
                scraper: StaticScraper()
            ),

            groupPersistenceManager: GroupCoreDataManager()
        )
    }

    public func buildScheduleViewModel() -> ScheduleViewModel {
        return ScheduleViewModel(
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

            groupSchedulePersistenceManager: GroupScheduleCoreDataManager(),

            lessonSubgroupsPersistenceManager: LessonSubgroupsUDManager(),

            groupSessionEventsPersistenceManager: GroupSessionEventsCoreDataManager()
        )
    }

    public func buildTeacherViewModel() -> TeacherViewModel {
        return TeacherViewModel(
            teacherNetworkManager: TeacherNetworkManagerWithParsing(
                scraper: StaticScraper()
            ),

            lessonsNetworkManager: LessonNetworkManagerWithParsing(
                urlSource: urlSource,
                lessonParser: LessonHTMLParserSGU_old(),
                scraper: StaticScraper()
            ),

            sessionEventsNetworkManager: SessionEventsNetworkManagerWithParsing(
                urlSource: urlSource,
                sessionEventsParser: SessionEventsHTMLParserSGU_old(),
                scraper: StaticScraper()
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
