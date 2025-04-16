//
//  ViewModelWithMockDataFactory.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 03.02.2025.
//

import Foundation

final class ViewModelWithMockDataFactory: ViewModelFactory {
    func buildDepartmentsViewModel() -> DepartmentsViewModel {
        return DepartmentsViewModel()
    }

    func buildGroupsViewModel(department: DepartmentDTO) -> GroupsViewModel {
        return GroupsViewModel(
            groupsNetworkManager: GroupsNetworkManagerMock(),
            groupPersistenceManager: GroupPersistenceManagerMock()
        )
    }

    func buildScheduleViewModel() -> ScheduleViewModel {
        return ScheduleViewModel(
            lessonsNetworkManager: LessonNetworkManagerMock(),
            sessionEventsNetworkManager: SessionEventsNetworkManagerMock(),
            groupSchedulePersistenceManager: GroupSchedulePersistenceManagerMock(),
            lessonSubgroupsPersistenceManager: LessonSubgroupsPersistenceManagerMock(),
            groupSessionEventsPersistenceManager: GroupSessionEventsPersistenceManagerMock()
        )
    }

    func buildTeacherViewModel() -> TeacherViewModel {
        return TeacherViewModel(
            teacherNetworkManager: TeacherNetworkManagerMock(),
            lessonsNetworkManager: LessonNetworkManagerMock(),
            sessionEventsNetworkManager: SessionEventsNetworkManagerMock()
        )
    }

    func buildTeachersSearchViewModel() -> TeachersSearchViewModel {
        return TeachersSearchViewModel(
            teacherNetworkManager: TeacherNetworkManagerMock(),
            teacherSearchResultsUDManager: TeacherSearchResultsPersistenceManagerMock()
        )
    }
}
