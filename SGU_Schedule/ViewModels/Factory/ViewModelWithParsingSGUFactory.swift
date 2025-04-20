//
//  ViewModelWithParsingSGUFactory.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 31.05.2024.
//

import Foundation

final class ViewModelWithParsingSGUFactory: ViewModelFactory {
    private let networkManagerFactory = NetworkManagerWithParsingSGUFactory()

    func buildDepartmentsViewModel() -> DepartmentsViewModel {
        return DepartmentsViewModel()
    }

    func buildGroupsViewModel(department: DepartmentDTO) -> GroupsViewModel {
        return GroupsViewModel(
            groupsInteractor: GroupsInteractorImpl(
                groupsNetworkManager: networkManagerFactory.makeGroupsNetworkManager(),
                groupPersistenceManager: GroupCoreDataManager()
            )
        )
    }

    func buildScheduleViewModel() -> ScheduleViewModel {
        return ScheduleViewModel(
            scheduleInteractor: ScheduleInteractorImpl(
                lessonsNetworkManager: networkManagerFactory.makeLessonsNetworkManager(),
                sessionEventsNetworkManager: networkManagerFactory.makeSessionEventsNetworkManager(),
                groupSchedulePersistenceManager: GroupScheduleCoreDataManager(),
                lessonSubgroupsPersistenceManager: LessonSubgroupsUDManager(),
                groupSessionEventsPersistenceManager: GroupSessionEventsCoreDataManager()
            )
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
