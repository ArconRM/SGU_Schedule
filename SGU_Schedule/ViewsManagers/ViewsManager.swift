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
/// Manages creating views and passing data
public final class ViewsManager: ObservableObject {
    private var currentViewModelFactory: ViewModelFactory
    private var viewModelFactory: ViewModelFactory
    private var viewModelFactory_old: ViewModelFactory
    
    private let schedulePersistenceManager: GroupSchedulePersistenceManager
    private let groupPersistenceManager: GroupPersistenceManager
    private var groupsViewModel: GroupsViewModel?
    
    //https://stackoverflow.com/questions/34474545/self-used-before-all-stored-properties-are-initialized
    //TODO: мб получше решение есть
    private var _selectedDepartment: DepartmentDTO?
    private var selectedDepartment: DepartmentDTO? {
        get {
            return _selectedDepartment
        }
        set(newValue) {
            UserDefaults.standard.setValue(newValue?.code, forKey: UserDefaultsKeys.selectedDepartmentKey.rawValue)
            _selectedDepartment = newValue
        }
    }
    
    private var _isNewParserUsed: Bool
    var isNewParserUsed: Bool {
        get {
            return _isNewParserUsed
        }
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKeys.isNewParserUsed.rawValue)
            _isNewParserUsed = newValue
        }
    }
    
    @Published private(set) var currentView: AppViews
    var needToReloadGroupView: Bool = false // Для айпада, ибо на нем вьюшка всегда на экране
    
    @Published var isShowingError = false
    @Published var activeError: LocalizedError?
    
    private var selectedGroup: AcademicGroupDTO?
    private var isSelectedGroupFavourite: Bool?
    private var isSelectedGroupPinned: Bool?
    
    private var teacherEndpoint: String?
    
    init(
        viewModelFactory: ViewModelFactory,
        viewModelFactory_old: ViewModelFactory,
        schedulePersistenceManager: GroupSchedulePersistenceManager,
        groupPersistenceManager: GroupPersistenceManager,
        isOpenedFromWidget: Bool
    ) {
        self.schedulePersistenceManager = schedulePersistenceManager
        self.groupPersistenceManager = groupPersistenceManager
        
        self._isNewParserUsed = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isNewParserUsed.rawValue)
        self.currentViewModelFactory = _isNewParserUsed ? viewModelFactory : viewModelFactory_old
        self.viewModelFactory = viewModelFactory
        self.viewModelFactory_old = viewModelFactory_old
        
        self._selectedDepartment = {
            if let departmentCode = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedDepartmentKey.rawValue) {
                return DepartmentDTO(code: departmentCode)
            }
            return nil
        }()
        
        if self._selectedDepartment != nil {
            groupsViewModel = self.currentViewModelFactory.buildGroupsViewModel(department: self._selectedDepartment!) // Не должен пересоздаваться без смены факультета
            currentView = .GroupsView
            
            // Если открыто с виджета, перебрасывает на вьюшку с избранной группой (если такова есть)
            do {
                if isOpenedFromWidget, let favouriteGroup = try groupPersistenceManager.getFavouriteGroupDTO() {
                    selectGroup(group: favouriteGroup, isFavourite: true, isPinned: false)
                    showScheduleView()
                }
            }
            catch (let error) {
                showCoreDataError(error: error)
            }
        } else {
            currentView = .DepartmentsView
        }
    }
    
    //Data
    func selectDepartment(department: DepartmentDTO) {
        selectedDepartment = department
        //TODO: мб чтобы все таки менялся groupsViewModel
    }
    
    func changeDepartment() {
        selectedDepartment = nil
        
//        do {
//            try schedulePersistenceManager.clearAllItems()
//            try groupPersistenceManager.clearAllItems()
//        }
//        catch (let error) {
//            showCoreDataError(error: error)
//        }
//
//        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func changeParser() {
        
//        do {
//            print(try groupPersistenceManager.fetchAllItemsDTO().count)
//            print(try schedulePersistenceManager.fetchAllItemsDTO().count)
//        }
//        catch {}
        
        isNewParserUsed.toggle()
        currentViewModelFactory = isNewParserUsed ? viewModelFactory : viewModelFactory_old
        groupsViewModel = currentViewModelFactory.buildGroupsViewModel(department: selectedDepartment!) // Не должен пересоздаваться без смены факультета/парсера
    }
    
    func selectGroup(group: AcademicGroupDTO, isFavourite: Bool, isPinned: Bool) {
        guard let _ = selectedDepartment else {
            showUserDefaultsError(error: UserDefaultsError.failedToFetch)
            return
        }
        selectedGroup = group
        isSelectedGroupFavourite = isFavourite
        isSelectedGroupPinned = isPinned
    }
    
    func saveGroup(group: AcademicGroupDTO) {
        do {
            try groupPersistenceManager.saveItem(group)
        }
        catch (let error) {
            showCoreDataError(error: error)
        }
    }
    
    func setFavouriteGroup(group: AcademicGroupDTO) {
        do {
            try groupPersistenceManager.makeGroupFavourite(group.groupId)
        }
        catch (let error) {
            showCoreDataError(error: error)
        }
    }
    
    func unpinGroup(group: AcademicGroupDTO) {
        do {
            try schedulePersistenceManager.deleteScheduleByGroupId(group.groupId)
            try groupPersistenceManager.deleteItemById(group.groupId)
        }
        catch (let error) {
            showCoreDataError(error: error)
        }
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
        let departmentsViewModel = currentViewModelFactory.buildDepartmentsViewModel()
        
        return DepartmentsView(viewModel: departmentsViewModel)
    }
    
    func buildGroupsView() -> some View {
        return GroupsView(viewModel: groupsViewModel!, selectedDepartment: selectedDepartment!)
        
    }
    
    func buildScheduleView() -> some View {
        let scheduleViewModel = currentViewModelFactory.buildScheduleViewModel()
        
        return ScheduleView(viewModel: scheduleViewModel, group: selectedGroup!, isFavourite: isSelectedGroupFavourite!, isPinned: isSelectedGroupPinned!)
    }
    
    func buildTeacherInfoView() -> some View {
        let teacherInfoViewModel = currentViewModelFactory.buildTeacherInfoViewModel()
        
        return TeacherInfoView(viewModel: teacherInfoViewModel, teacherEndpoint: teacherEndpoint ?? "")
    }
    
    //Error handling
    private func showCoreDataError(error: Error) {
        self.isShowingError = true
        
        if let coreDataError = error as? CoreDataError {
            self.activeError = coreDataError
        } else {
            self.activeError = CoreDataError.unexpectedError
        }
    }
    
    private func showUserDefaultsError(error: Error) {
        self.isShowingError = true
        
        if let userDefaultsError = error as? UserDefaultsError {
            self.activeError = userDefaultsError
        } else {
            self.activeError = UserDefaultsError.unexpectedError
        }
    }
}
