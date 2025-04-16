//
//  GroupsViewModel.swift
//  SGU_Schedule
//
//  Created by Артемий on 14.10.2023.
//

import Foundation

public class GroupsViewModel: BaseViewModel {
    private let groupsNetworkManager: GroupsNetworkManager
    private let groupPersistenceManager: GroupPersistenceManager

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
    @Published var isLoadingFavoriteGroup: Bool = true

    var wasLaunched: Bool {
        let wasLaunched = UserDefaults.standard.bool(forKey: UserDefaultsKeys.wasLaunched.rawValue)
        if !wasLaunched {
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.wasLaunched.rawValue)
        }

        return wasLaunched
    }

    init(
        groupsNetworkManager: GroupsNetworkManager,
        groupPersistenceManager: GroupPersistenceManager
    ) {
        self.groupsNetworkManager = groupsNetworkManager
        self.groupPersistenceManager = groupPersistenceManager
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
        do {
            self.isLoadingGroups = true

            self.favouriteGroup = try groupPersistenceManager.getFavouriteGroupDTO()
            if self.favouriteGroup != nil {
                favouriteGroupNumber = self.favouriteGroup!.fullNumber
            }

            self.savedGroupsWithoutFavourite = try groupPersistenceManager.fetchAllItemsDTO().filter {
                $0.groupId != favouriteGroup?.groupId
            }

            if isOnline {
                groupsNetworkManager.getGroupsByYearAndAcademicProgram(
                    year: year,
                    program: academicProgram,
                    department: selectedDepartment,
                    resultQueue: .main
                ) { result in
                    switch result {
                    case .success(let groups):
                        self.groupsWithoutSaved = groups.filter {
                            $0 != self.favouriteGroup &&
                            !self.savedGroupsWithoutFavourite.contains($0)
                        }
                    case .failure(let error):
                        self.groupsWithoutSaved = []
                        self.showNetworkError(error)
                    }
                    self.isLoadingGroups = false
                }
            } else {
                self.isLoadingGroups = false
            }
        } catch let error {
            self.showCoreDataError(error)
        }
    }
}
