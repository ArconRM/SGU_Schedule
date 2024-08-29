//
//  ViewsManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 01.02.2024.
//

import Foundation
import SwiftUI
import WidgetKit


enum AppViews {
    case DepartmentsView
    case GroupsView
    case ScheduleView
    case TeacherInfoView
}

// TODO: через DI с протоколом сделать
// TODO: слишком много обязанностей
// TODO: может как то без него кастомную навигацию
/// Manages creating views and passing data
public final class ViewsManager: ObservableObject {
    
    private var viewModelFactory: ViewModelFactory
    private var groupsViewModel: GroupsViewModel?
    private let schedulePersistenceManager: GroupSchedulePersistenceManager
    
    @Published private(set) var currentView: AppViews
    var needToReloadGroupView: Bool = false // Для айпада, ибо на нем вьюшка всегда на экране
    
    private var selectedDepartmentCode: String? = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedDepartmentKey.rawValue)
    private var favoriteGroupNumber: Int = UserDefaults.standard.integer(forKey: UserDefaultsKeys.favoriteGroupNumberKey.rawValue)
    private var selectedGroup: GroupDTO?
    private var teacherEndpoint: String?
    
    init(viewModelFactory: ViewModelFactory, schedulePersistenceManager: GroupSchedulePersistenceManager) {
        self.viewModelFactory = viewModelFactory
        self.schedulePersistenceManager = schedulePersistenceManager
        
        if selectedDepartmentCode != nil {
            groupsViewModel = self.viewModelFactory.buildGroupsViewModel(department: DepartmentSource(rawValue: selectedDepartmentCode!)!.dto) // Не должен пересоздаваться без смены факультета
            currentView = .GroupsView
        } else {
            currentView = .DepartmentsView
        }
    }
    
    //Data
    func selectDepartment(departmentCode: String) {
        UserDefaults.standard.setValue(departmentCode, forKey: UserDefaultsKeys.selectedDepartmentKey.rawValue)
        selectedDepartmentCode = departmentCode
        groupsViewModel = viewModelFactory.buildGroupsViewModel(department: DepartmentSource(rawValue: departmentCode)!.dto) // Не должен пересоздаваться без смены факультета
    }
    
    func getSelectedDapertmentFullName() -> String {
        if selectedDepartmentCode != nil {
            return DepartmentSource(rawValue: selectedDepartmentCode!)!.fullName
        }
        return "Error"
    }
    
    func selectGroup(group: GroupDTO) {
        selectedGroup = group
    }
    
    func resetDepartment() {
        UserDefaults.standard.setValue(nil, forKey: UserDefaultsKeys.selectedDepartmentKey.rawValue)
        selectedDepartmentCode = nil
        
        UserDefaults.standard.setValue(0, forKey: UserDefaultsKeys.favoriteGroupNumberKey.rawValue)
        favoriteGroupNumber = 0
        
        do {
            try schedulePersistenceManager.clearAllItems()
        }
        catch (let error) {
            // TODO: нормально отловить
            print(error.localizedDescription)
        }
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    //Transitions
    func showDepartmentsView() {
        currentView = .DepartmentsView
    }
    
    func showGroupsView(needToReload: Bool) {
        needToReloadGroupView = needToReload
        currentView = .GroupsView
    }
    
    func showScheduleView() {
        currentView = .ScheduleView
    }
    
    func showTeacherInfoView(teacherEndpoint: String) {
        self.teacherEndpoint = teacherEndpoint
        currentView = .TeacherInfoView
    }
    
    //Factory
    func buildDepartmentsView() -> some View {
        let departmentsViewModel = viewModelFactory.buildDepartmentsViewModel()
        
        return DepartmentsView(viewModel: departmentsViewModel)
    }
    
    func buildGroupsView() -> some View {
        return GroupsView(viewModel: groupsViewModel!)
    }
    
    func buildScheduleView() -> some View {
        let scheduleViewModel = viewModelFactory.buildScheduleViewModel(department: DepartmentDTO(fullName: "", code: selectedDepartmentCode!))
        
        return ScheduleView(viewModel: scheduleViewModel, selectedGroup: selectedGroup)
    }
    
    func buildTeacherInfoView() -> some View {
        let teacherInfoViewModel = viewModelFactory.buildTeacherInfoViewModel()
        
        return TeacherInfoView(viewModel: teacherInfoViewModel, teacherEndpoint: teacherEndpoint ?? "")
    }
}
