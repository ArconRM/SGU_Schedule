//
//  ViewModelFactory.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 31.05.2024.
//

import Foundation

protocol ViewModelFactory {
    func buildDepartmentsViewModel() -> DepartmentsViewModel

    func buildGroupsViewModel(department: DepartmentDTO) -> GroupsViewModel

    func buildScheduleViewModel() -> ScheduleViewModel

    func buildTeacherViewModel() -> TeacherViewModel

    func buildTeachersSearchViewModel() -> TeachersSearchViewModel
}
