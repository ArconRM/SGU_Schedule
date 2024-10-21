//
//  ViewModelFactory.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 31.05.2024.
//

import Foundation

public protocol ViewModelFactory {
    func buildDepartmentsViewModel() -> DepartmentsViewModel
    
    func buildGroupsViewModel(department: Department) -> GroupsViewModel
    
    func buildScheduleViewModel() -> ScheduleViewModel
    
    func buildTeacherInfoViewModel() -> TeacherInfoViewModel
}
