//
//  ViewsManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 01.02.2024.
//

import Foundation
import SwiftUI
import WidgetKit

// TODO: слишком много обязанностей, по-хорошему бы часть вынести в координатор
/// Manages creating and routing views
public final class ViewsManager: ObservableObject {
    private var currentViewModelFactory: ViewModelFactory
    private var viewModelFactory: ViewModelFactory
    private var viewModelFactory_old: ViewModelFactory

    private let groupSchedulePersistenceManager: GroupSchedulePersistenceManager
    private let groupSessionEventsPersistenceManager: GroupSessionEventsPersistenceManager
    private let groupPersistenceManager: GroupPersistenceManager
    private var groupsViewModel: GroupsViewModel?

    @Published private var appearanceSettings: AppearanceSettingsStore
    @Published private var persistentUserSettings: PersistentUserSettingsStore
    @Published private var routingState: RoutingState

    private var currentView: AppViews {
        routingState.currentView
    }

    private var isShowingSettingsView: Bool {
        routingState.isShowingSettingsView
    }

    var currentViewPublisher: Published<AppViews>.Publisher {
        routingState.$currentView
    }

    var isShowingSettingsViewPublisher: Published<Bool>.Publisher {
        routingState.$isShowingSettingsView
    }

    @Published var needToReloadGroupView: Bool = false

    @Published var isShowingError = false
    @Published var activeError: LocalizedError?

    init(
        appearanceSettings: AppearanceSettingsStore,
        persistentUserSettings: PersistentUserSettingsStore,
        routingState: RoutingState,
        viewModelFactory: ViewModelFactory,
        viewModelFactory_old: ViewModelFactory,
        groupSchedulePersistenceManager: GroupSchedulePersistenceManager,
        groupSessionEventsPersistenceManager: GroupSessionEventsPersistenceManager,
        groupPersistenceManager: GroupPersistenceManager,
        widgetUrl: String? = nil
    ) {
        self.appearanceSettings = appearanceSettings
        self.persistentUserSettings = persistentUserSettings
        self.routingState = routingState

        self.groupSchedulePersistenceManager = groupSchedulePersistenceManager
        self.groupSessionEventsPersistenceManager = groupSessionEventsPersistenceManager
        self.groupPersistenceManager = groupPersistenceManager

        self.currentViewModelFactory = persistentUserSettings.isNewParserUsed ? viewModelFactory : viewModelFactory_old
        self.viewModelFactory = viewModelFactory
        self.viewModelFactory_old = viewModelFactory_old

        if persistentUserSettings.selectedDepartment != nil {
            groupsViewModel = self.currentViewModelFactory.buildGroupsViewModel(department: persistentUserSettings.selectedDepartment!) // Не должен пересоздаваться без смены факультета
            routingState.currentView = .groupsView

            // Если открыто с виджета, перебрасывает на вьюшку с избранной группой (если она выбрана)
            do {
                if let widgetUrl = widgetUrl, let favouriteGroup = try groupPersistenceManager.getFavouriteGroupDTO() {
                    selectGroup(group: favouriteGroup, isFavourite: true, isPinned: false)

                    if widgetUrl == AppUrls.isOpenedFromScheduleWidget.rawValue {
                        showScheduleView()
                    } else if widgetUrl == AppUrls.isOpenedFromSessionWidget.rawValue {
                        showSessionEventsView()
                    }
                }
            } catch let error {
                handleError(error)
            }
        } else {
            routingState.currentView = .departmentsView
        }
    }

    // MARK: - Data Methods
    func changeParser() {
        persistentUserSettings.isNewParserUsed.toggle()
        currentViewModelFactory = persistentUserSettings.isNewParserUsed ? viewModelFactory : viewModelFactory_old
    }

    func selectDepartment(department: DepartmentDTO) {
        persistentUserSettings.selectedDepartment = department
        // TODO: мб чтобы все таки менялся groupsViewModel
        groupsViewModel = self.currentViewModelFactory.buildGroupsViewModel(department: persistentUserSettings.selectedDepartment!)
    }

    func clearDepartment() {
        persistentUserSettings.selectedDepartment = nil
    }

    func selectGroup(group: AcademicGroupDTO, isFavourite: Bool, isPinned: Bool) {
        guard persistentUserSettings.selectedDepartment != nil else {
            handleError(UserDefaultsError.failedToFetch)
            return
        }
        routingState.currentView = .groupsView
        routingState.selectedGroup = group
        routingState.isSelectedGroupFavourite = isFavourite
        routingState.isSelectedGroupPinned = isPinned
    }

    func saveGroup(group: AcademicGroupDTO) {
        do {
            try groupPersistenceManager.saveItem(group)
        } catch let error {
            handleError(error)
        }
    }

    func setFavouriteGroup(group: AcademicGroupDTO) {
        do {
            try groupPersistenceManager.makeGroupFavourite(group.groupId)
            persistentUserSettings.favouriteGroupNumber = group.fullNumber
        } catch let error {
            handleError(error)
        }
    }

    func deleteGroupFromPersistence(group: AcademicGroupDTO) {
        do {
            try groupSchedulePersistenceManager.deleteScheduleByGroupId(group.groupId)
            try groupSessionEventsPersistenceManager.deleteSessionEventsByGroupId(group.groupId)
            try groupPersistenceManager.deleteItemById(group.groupId)
        } catch let error {
            handleError(error)
        }
    }

    // MARK: - Views Transitions
    func showDepartmentsView() {
        routingState.currentView = .departmentsView
        routingState.isShowingSettingsView = false
        routingState.selectedGroup = nil
    }

    func showGroupsView(needToReload: Bool = false) {
        needToReloadGroupView = needToReload
        routingState.currentView = .groupsView
        routingState.isShowingSettingsView = false
        routingState.selectedGroup = nil
    }

    func showSettingsView() {
        routingState.isShowingSettingsView = true
    }

    func showScheduleView() {
        routingState.selectedTeacherUrlEndpoint = nil
        routingState.selectedTeacherLessonsUrlEndpoint = nil

        if routingState.selectedGroup == nil {
            handleError(BaseError.noSavedDataError)
        } else {
            routingState.currentView = .scheduleView
        }
    }

    func showSessionEventsView() {
        routingState.selectedTeacherUrlEndpoint = nil
        routingState.selectedTeacherLessonsUrlEndpoint = nil

        if routingState.selectedGroup == nil {
            handleError(BaseError.noSavedDataError)
        } else {
            routingState.currentView = .sessionEventsView
        }
    }

    /// Если передана ссылка на самого преподавателя, показывает всю инфу.
    /// Если передана ссылка на его расписание, то только расписание.
    func showTeacherView(teacherUrlEndpoint: String) {
        routingState.selectedTeacherUrlEndpoint = teacherUrlEndpoint
        routingState.currentView = .teacherView
    }

    /// Если передана ссылка на самого преподавателя, показывает всю инфу.
    /// Если передана ссылка на его расписание, то только расписание.
    func showTeacherView(teacherLessonsUrlEndpoint: String) {
        routingState.selectedTeacherLessonsUrlEndpoint = teacherLessonsUrlEndpoint
        routingState.currentView = .teacherView
    }

    func showTeachersSearchView() {
        routingState.currentView = .teachersSearchView
    }

    // MARK: - Factory
    func buildDepartmentsView() -> some View {
        let departmentsViewModel = currentViewModelFactory.buildDepartmentsViewModel()

        return DepartmentsView(viewModel: departmentsViewModel)
    }

    func buildGroupsView() -> some View {
        return GroupsView(viewModel: groupsViewModel!, selectedDepartment: persistentUserSettings.selectedDepartment ?? DepartmentDTO(code: "Error"))
    }

    func buildSettingsView() -> some View {
        return SettingsView(
            selectedDepartment: persistentUserSettings.selectedDepartment ?? DepartmentDTO(code: "Error"),
            selectedTheme: appearanceSettings.currentAppTheme,
            selectedStyle: appearanceSettings.currentAppStyle,
            selectedParser: persistentUserSettings.isNewParserUsed ? .new : .old
        )
    }

    func buildScheduleView(showSessionEventsView: Bool = false) -> some View {
        let scheduleViewModel = currentViewModelFactory.buildScheduleViewModel()

        return ScheduleView(
            viewModel: scheduleViewModel,
            group: routingState.selectedGroup ?? AcademicGroupDTO(fullNumber: "Error", departmentCode: "Error"),
            isFavourite: routingState.isSelectedGroupFavourite!,
            isPinned: routingState.isSelectedGroupPinned!,
            showSessionEventsView: showSessionEventsView
        )
    }

    func buildTeacherView() -> some View {
        let teacherViewModel = currentViewModelFactory.buildTeacherViewModel()

        if routingState.selectedTeacherUrlEndpoint != nil {
            return TeacherView(viewModel: teacherViewModel, teacherEndpoint: routingState.selectedTeacherUrlEndpoint)
        } else {
            return TeacherView(viewModel: teacherViewModel, teacherLessonsEndpoint: routingState.selectedTeacherLessonsUrlEndpoint)
        }
    }

    func buildTeachersSearchView() -> some View {
        let teachersSearchViewModel = currentViewModelFactory.buildTeachersSearchViewModel()

        return TeachersSearchView(viewModel: teachersSearchViewModel)
    }

    // MARK: - Error Handling
    private func handleError(_ error: Error) {
        isShowingError = true
        switch error {
        case let error as CoreDataError:
            activeError = error
        case let error as UserDefaultsError:
            activeError = error
        case let error as BaseError:
            activeError = error
        default:
            activeError = BaseError.unknownError
        }
    }
}
