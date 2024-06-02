//
//  ViewModelFactory.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 31.05.2024.
//

import Foundation

public protocol ViewModelFactory {
    func buildScheduleViewModel() -> ScheduleViewModel
    
    func buildGroupsViewModel() -> GroupsViewModel
    
    func buildTeacherInfoViewModel() -> TeacherInfoViewModel
}
