//
//  ViewModelWithParsingSGUFactory_old.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 06.09.2024.
//

import Foundation

final class ViewModelWithParsingSGUFactory_old: ViewModelFactory {
    private let networkManagerFactory = NetworkManagerWithParsingSGUFactory_old()

    func buildDepartmentsViewModel() -> DepartmentsViewModel {
        return DepartmentsViewModel()
    }

    func buildGroupsViewModel(department: DepartmentDTO) -> GroupsViewModel {
        return GroupsViewModel(
            groupsNetworkManager: networkManagerFactory.makeGroupsNetworkManager(),

            groupPersistenceManager: GroupCoreDataManager()
        )
    }

    func buildScheduleViewModel() -> ScheduleViewModel {
        return ScheduleViewModel(
            lessonsNetworkManager: networkManagerFactory.makeLessonsNetworkManager(),

            sessionEventsNetworkManager: networkManagerFactory.makeSessionEventsNetworkManager(),

            groupSchedulePersistenceManager: GroupScheduleCoreDataManager(),

            lessonSubgroupsPersistenceManager: LessonSubgroupsUDManager(),

            groupSessionEventsPersistenceManager: GroupSessionEventsCoreDataManager()
        )
    }

    func buildTeacherViewModel() -> TeacherViewModel {
        return TeacherViewModel(
            teacherNetworkManager: networkManagerFactory.makeTeacherNetworkManager(),

            lessonsNetworkManager: networkManagerFactory.makeLessonsNetworkManager(),

            sessionEventsNetworkManager: networkManagerFactory.makeSessionEventsNetworkManager()
        )
    }

    func buildTeachersSearchViewModel() -> TeachersSearchViewModel {
        return TeachersSearchViewModel(
            teacherNetworkManager: networkManagerFactory.makeTeacherNetworkManager(),
            teacherSearchResultsUDManager: TeacherSearchResultsUDManager()
        )
    }
}
