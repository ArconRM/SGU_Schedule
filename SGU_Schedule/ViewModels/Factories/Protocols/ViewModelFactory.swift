//
//  ViewModelFactory.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 31.05.2024.
//

import Foundation

public protocol ViewModelFactory {
    func buildDepartmentsViewModel() -> DepartmentsViewModel
    
    func buildGroupsViewModel(department: DepartmentDTO) -> GroupsViewModel
    
    func buildScheduleViewModel(selectedDepartmentCode: String) -> ScheduleViewModel
    
    func buildTeacherInfoViewModel() -> TeacherInfoViewModel
}
