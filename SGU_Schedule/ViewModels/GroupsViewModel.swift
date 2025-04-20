//
//  GroupsViewModel.swift
//  SGU_Schedule
//
//  Created by Артемий on 14.10.2023.
//

import Foundation

public class GroupsViewModel: BaseViewModel {
    private let groupsInteractor: GroupsInteractor

    private let selectedAcademicProgramKey = "selectedAcademicProgram"
    private let selectedYearKey = "selectedYear"

    private var favouriteGroupNumber: String? {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKeys.favoriteGroupNumberKey.rawValue)
        }
        set(newValue) {
            UserDefaults.standard.setValue(newValue, forKey: UserDefaultsKeys.favoriteGroupNumberKey.rawValue)
        }
    }

    @Published var favouriteGroup: AcademicGroupDTO?
    @Published var savedGroupsWithoutFavourite = [AcademicGroupDTO]()
    @Published var groupsWithoutSaved = [AcademicGroupDTO]()

    @Published var isLoadingGroups: Bool = true

    var wasLaunched: Bool {
        let wasLaunched = UserDefaults.standard.bool(forKey: UserDefaultsKeys.wasLaunched.rawValue)
        if !wasLaunched {
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.wasLaunched.rawValue)
        }

        return wasLaunched
    }

    init(groupsInteractor: GroupsInteractor) {
        self.groupsInteractor = groupsInteractor
    }

    public func getSelectedAcademicProgram() -> AcademicProgram {
        if UserDefaults.standard.string(forKey: selectedAcademicProgramKey) == nil {
            UserDefaults.standard.set(AcademicProgram.bachelorAndSpeciality.rawValue, forKey: selectedAcademicProgramKey)
        }

        return AcademicProgram(rawValue: UserDefaults.standard.string(forKey: selectedAcademicProgramKey) ?? "Error") ?? .bachelorAndSpeciality
    }

    public func getSelectedYear() -> Int {
        if UserDefaults.standard.value(forKey: selectedYearKey) == nil {
            UserDefaults.standard.set(1, forKey: selectedYearKey)
        }

        return UserDefaults.standard.integer(forKey: selectedYearKey)
    }

    public func setSelectedAcademicProgramAndFetchGroups(
        newValue: AcademicProgram,
        selectedDepartment: DepartmentDTO,
        isOnline: Bool
    ) {
        UserDefaults.standard.set(newValue.rawValue, forKey: selectedAcademicProgramKey)
        fetchGroups(
            year: getSelectedYear(),
            academicProgram: newValue,
            selectedDepartment: selectedDepartment,
            isOnline: isOnline
        )
    }

    public func setSelectedYearAndFetchGroups(
        newValue: Int,
        selectedDepartment: DepartmentDTO,
        isOnline: Bool
    ) {
        UserDefaults.standard.set(newValue, forKey: selectedYearKey)
        fetchGroups(
            year: newValue,
            academicProgram: getSelectedAcademicProgram(),
            selectedDepartment: selectedDepartment,
            isOnline: isOnline
        )
    }

    public func fetchGroups(
        year: Int,
        academicProgram: AcademicProgram,
        selectedDepartment: DepartmentDTO,
        isOnline: Bool
    ) {
        self.isLoadingGroups = true

        groupsInteractor.fetchFavouriteGroup { result in
            switch result {
            case .success(let group):
                self.favouriteGroup = group
                if self.favouriteGroup != nil {
                    self.favouriteGroupNumber = self.favouriteGroup!.fullNumber
                }
            case .failure(let error):
                self.showError(error)
            }
        }

        groupsInteractor.fetchSavedGroupsWithoutFavourite { result in
            switch result {
            case .success(let groups):
                self.savedGroupsWithoutFavourite = groups.filter {
                    $0.groupId != self.favouriteGroup?.groupId
                }
            case .failure(let error):
                self.showError(error)
            }
        }

        groupsInteractor.fetchNertworkGroups(
            year: year,
            academicProgram: academicProgram,
            selectedDepartment: selectedDepartment,
            isOnline: isOnline
        ) { result in
            switch result {
            case .success(let groups):
                self.groupsWithoutSaved = groups.filter { $0 != self.favouriteGroup && !self.savedGroupsWithoutFavourite.contains($0) }
            case .failure(let error):
                self.showError(error)
            }

            self.isLoadingGroups = false
        }
    }
}
