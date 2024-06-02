//
//  ViewsManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 01.02.2024.
//

import Foundation
import SwiftUI


enum AppViews {
    case GroupsView
    case ScheduleView
    case TeacherInfoView
}

// TODO: через DI с протоколом сделать
/// Manages creating views and passing data
public final class ViewsManager: ObservableObject {
    
    private var viewModelFactory: ViewModelFactory
    private var groupsViewModel: GroupsViewModel
    
    @Published private(set) var currentView: AppViews
    @Published private(set) var selectedGroup: GroupDTO?
    @Published private(set) var teacherEndpoint: String?
    
    //Для айпада, ибо на нем вьюшка всегда на экране
    var needToReloadGroupView: Bool = false
    
    
    init(viewModelFactory: ViewModelFactory) {
        self.viewModelFactory = viewModelFactory
        self.groupsViewModel = self.viewModelFactory.buildGroupsViewModel() // Должен создаваться сразу и только один раз
        self.currentView = .GroupsView
    }
    
    //Transitions
    func showGroupsView(needToReload: Bool) {
        self.needToReloadGroupView = needToReload
        self.currentView = .GroupsView
    }
    
    func showScheduleView(selectedGroup: GroupDTO? = nil) {
        if let _ = selectedGroup {
            self.selectedGroup = selectedGroup
        }
        self.currentView = .ScheduleView
    }
    
    func showTeacherInfoView(teacherEndpoint: String) {
        self.teacherEndpoint = teacherEndpoint
        self.currentView = .TeacherInfoView
    }
    
    //Builds
    func buildGroupsView() -> some View {
        return GroupsView(viewModel: self.groupsViewModel)
    }
    
    func buildScheduleView() -> some View {
        let scheduleViewModel = self.viewModelFactory.buildScheduleViewModel()
        
        return ScheduleView(viewModel: scheduleViewModel, selectedGroup: self.selectedGroup)
    }
    
    func buildTeacherInfoView() -> some View {
        let teacherInfoViewModel = self.viewModelFactory.buildTeacherInfoViewModel()
        
        return TeacherInfoView(viewModel: teacherInfoViewModel, teacherEndpoint: self.teacherEndpoint ?? "")
    }
}
