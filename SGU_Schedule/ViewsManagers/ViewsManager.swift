//
//  ViewsManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 01.02.2024.
//

import Foundation
import SwiftUI
import WidgetKit

enum AppViews: Equatable {
    case departmentsView
    case groupsView
    case scheduleView
    case teacherView
    case teachersSearchView
}

// TODO: через DI с протоколом сделать
// TODO: слишком много обязанностей
/// Manages creating views and passing data
public final class ViewsManager: ObservableObject {
    private var currentViewModelFactory: ViewModelFactory
    private var viewModelFactory: ViewModelFactory
    private var viewModelFactory_old: ViewModelFactory

    private let appSettings: AppSettings
    private let groupSchedulePersistenceManager: GroupSchedulePersistenceManager
    private let groupSessionEventsPersistenceManager: GroupSessionEventsPersistenceManager
    private let groupPersistenceManager: GroupPersistenceManager
    private var groupsViewModel: GroupsViewModel?

    // https://stackoverflow.com/questions/34474545/self-used-before-all-stored-properties-are-initialized
    // TODO: мб получше решение есть
    private var _selectedDepartment: Department?
    private var selectedDepartment: Department? {
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

    private var favouriteGroupNumber: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.favoriteGroupNumberKey.rawValue)
        }
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKeys.favoriteGroupNumberKey.rawValue)
        }
    }

    @Published private(set) var currentView: AppViews
    // Отдельно чтобы вьюшка с группами не переебашивалась из-за изменения currentView
    @Published private(set) var isShowingSettingsView: Bool = false

    var needToReloadGroupView: Bool = false

    @Published var isShowingError = false
    @Published var activeError: LocalizedError?

    private var selectedGroup: AcademicGroupDTO?
    private var isSelectedGroupFavourite: Bool?
    private var isSelectedGroupPinned: Bool?

    private var selectedTeacherUrlEndpoint: String?
    private var selectedTeacherLessonsUrlEndpoint: String?

    init(
        appSettings: AppSettings,
        viewModelFactory: ViewModelFactory,
        viewModelFactory_old: ViewModelFactory,
        groupSchedulePersistenceManager: GroupSchedulePersistenceManager,
        groupSessionEventsPersistenceManager: GroupSessionEventsPersistenceManager,
        groupPersistenceManager: GroupPersistenceManager,
        isOpenedFromWidget: Bool
    ) {
        self.appSettings = appSettings
        self.groupSchedulePersistenceManager = groupSchedulePersistenceManager
        self.groupSessionEventsPersistenceManager = groupSessionEventsPersistenceManager
        self.groupPersistenceManager = groupPersistenceManager

        self._isNewParserUsed = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isNewParserUsed.rawValue)
        self.currentViewModelFactory = _isNewParserUsed ? viewModelFactory : viewModelFactory_old
        self.viewModelFactory = viewModelFactory
        self.viewModelFactory_old = viewModelFactory_old

        self._selectedDepartment = {
            if let departmentCode = UserDefaults.standard.string(forKey: UserDefaultsKeys.selectedDepartmentKey.rawValue) {
                return Department(code: departmentCode)
            }
            return nil
        }()

        if self._selectedDepartment != nil {
            groupsViewModel = self.currentViewModelFactory.buildGroupsViewModel(department: self._selectedDepartment!) // Не должен пересоздаваться без смены факультета
            currentView = .groupsView

            // Если открыто с виджета, перебрасывает на вьюшку с избранной группой (если она выбрана)
            do {
                if isOpenedFromWidget, let favouriteGroup = try groupPersistenceManager.getFavouriteGroupDTO() {
                    selectGroup(group: favouriteGroup, isFavourite: true, isPinned: false)
                    showScheduleView()
                }
            } catch let error {
                showCoreDataError(error: error)
            }
        } else {
            currentView = .departmentsView
        }
    }

    // MARK: - Data
    func selectDepartment(department: Department) {
        selectedDepartment = department
        // TODO: мб чтобы все таки менялся groupsViewModel
        groupsViewModel = self.currentViewModelFactory.buildGroupsViewModel(department: self._selectedDepartment!)
    }

    func clearDepartment() {
        selectedDepartment = nil
    }

    func changeParser() {
        isNewParserUsed.toggle()
        currentViewModelFactory = isNewParserUsed ? viewModelFactory : viewModelFactory_old
    }

    func selectGroup(group: AcademicGroupDTO, isFavourite: Bool, isPinned: Bool) {
        guard selectedDepartment != nil else {
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
        } catch let error {
            showCoreDataError(error: error)
        }
    }

    func setFavouriteGroup(group: AcademicGroupDTO) {
        do {
            try groupPersistenceManager.makeGroupFavourite(group.groupId)
            favouriteGroupNumber = group.fullNumber
        } catch let error {
            showCoreDataError(error: error)
        }
    }

    func deleteGroupFromPersistence(group: AcademicGroupDTO) {
        do {
            try groupSchedulePersistenceManager.deleteScheduleByGroupId(group.groupId)
            try groupSessionEventsPersistenceManager.deleteSessionEventsByGroupId(group.groupId)
            try groupPersistenceManager.deleteItemById(group.groupId)
        } catch let error {
            showCoreDataError(error: error)
        }
    }

    // MARK: - Transitions
    func showDepartmentsView() {
        currentView = .departmentsView
        isShowingSettingsView = false
        selectedGroup = nil
    }

    func showGroupsView(needToReload: Bool = false) {
        needToReloadGroupView = needToReload
        currentView = .groupsView
        isShowingSettingsView = false
        selectedGroup = nil
    }

    func showSettingsView() {
        isShowingSettingsView = true
    }

    func showScheduleView() {
        selectedTeacherUrlEndpoint = nil
        selectedTeacherLessonsUrlEndpoint = nil

        if selectedGroup == nil {
            showBaseError(error: BaseError.noSavedDataError)
        } else {
            currentView = .scheduleView
        }
    }

    /// Если передана ссылка на самого преподавателя, показывает всю инфу.
    /// Если передана ссылка на его расписание, то только расписание.
    func showTeacherView(teacherUrlEndpoint: String) {
        self.selectedTeacherUrlEndpoint = teacherUrlEndpoint
        currentView = .teacherView
    }

    /// Если передана ссылка на самого преподавателя, показывает всю инфу.
    /// Если передана ссылка на его расписание, то только расписание.
    func showTeacherView(teacherLessonsUrlEndpoint: String) {
        self.selectedTeacherLessonsUrlEndpoint = teacherLessonsUrlEndpoint
        currentView = .teacherView
    }

    func showTeachersSearchView() {
        currentView = .teachersSearchView
    }

    // MARK: - Factory
    func buildDepartmentsView() -> some View {
        let departmentsViewModel = currentViewModelFactory.buildDepartmentsViewModel()

        return DepartmentsView(viewModel: departmentsViewModel)
    }

    func buildGroupsView() -> some View {
        return GroupsView(viewModel: groupsViewModel!, selectedDepartment: selectedDepartment ?? Department(code: "Error"))
    }

    func buildSettingsView() -> some View {
        return SettingsView(selectedDepartment: selectedDepartment ?? Department(code: "Error"),
                            selectedTheme: appSettings.currentAppTheme,
                            selectedStyle: appSettings.currentAppStyle,
                            selectedParser: isNewParserUsed ? .new : .old)
    }

    func buildScheduleView() -> some View {
        let scheduleViewModel = currentViewModelFactory.buildScheduleViewModel()

        return ScheduleView(viewModel: scheduleViewModel, group: selectedGroup!, isFavourite: isSelectedGroupFavourite!, isPinned: isSelectedGroupPinned!)
    }

    func buildTeacherView() -> some View {
        let teacherViewModel = currentViewModelFactory.buildTeacherViewModel()

        if selectedTeacherUrlEndpoint != nil {
            return TeacherView(viewModel: teacherViewModel, teacherEndpoint: selectedTeacherUrlEndpoint)
        } else {
            return TeacherView(viewModel: teacherViewModel, teacherLessonsEndpoint: selectedTeacherLessonsUrlEndpoint)
        }
    }

    func buildTeachersSearchView() -> some View {
        let teachersSearchViewModel = currentViewModelFactory.buildTeachersSearchViewModel()

        return TeachersSearchView(viewModel: teachersSearchViewModel)
    }

    // MARK: - Error handling
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

    private func showBaseError(error: Error) {
        self.isShowingError = true

        if let baseError = error as? BaseError {
            self.activeError = baseError
        } else {
            self.activeError = BaseError.unknownError
        }
    }
}
