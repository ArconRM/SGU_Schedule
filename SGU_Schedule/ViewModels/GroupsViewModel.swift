//
//  GroupsViewModel.swift
//  SGU_Schedule
//
//  Created by Артемий on 14.10.2023.
//

import Foundation

public final class GroupsViewModel: ObservableObject {
    private let networkManager: GroupsNetworkManager
    private let groupPersistenceManager: GroupPersistenceManager
    
    private let selectedAcademicProgramKey = "selectedAcademicProgram"
    private let selectedYearKey = "selectedYear"
    
    @Published var favouriteGroup: AcademicGroupDTO? = nil
    @Published var savedGroupsWithoutFavourite = [AcademicGroupDTO]()
    @Published var groupsWithoutSaved = [AcademicGroupDTO]()
    
    @Published var isLoadingGroups: Bool = true
    @Published var isLoadingFavoriteGroup: Bool = true
    
    @Published var isShowingError = false
    @Published var activeError: LocalizedError?
    
    var wasLaunched: Bool {
        let wasLaunched = UserDefaults.standard.bool(forKey: UserDefaultsKeys.wasLaunched.rawValue)
        if !wasLaunched {
            UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.wasLaunched.rawValue)
        }
        
        return wasLaunched
    }
    
    init(
        networkManager: GroupsNetworkManager,
        groupPersistenceManager: GroupPersistenceManager
    ) {
        self.networkManager = networkManager
        self.groupPersistenceManager = groupPersistenceManager
    }
    
    public func getSelectedAcademicProgram() -> AcademicProgram {
        if UserDefaults.standard.string(forKey: selectedAcademicProgramKey) == nil {
            UserDefaults.standard.set(AcademicProgram.BachelorAndSpeciality.rawValue, forKey: selectedAcademicProgramKey)
        }
        
        return AcademicProgram(rawValue: UserDefaults.standard.string(forKey: selectedAcademicProgramKey) ?? "Error") ?? .BachelorAndSpeciality
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
            self.savedGroupsWithoutFavourite = try groupPersistenceManager.fetchAllItemsDTO().filter {
                $0.groupId != favouriteGroup?.groupId
            }
            
            if isOnline {
                networkManager.getGroupsByYearAndAcademicProgram(
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
        }
        catch (let error) {
            showCoreDataError(error)
        }
    }
    
    private func showCoreDataError(_ error: Error) {
        self.isShowingError = true
        
        if let coreDataError = error as? CoreDataError {
            self.activeError = coreDataError
        } else {
            self.activeError = CoreDataError.unexpectedError
        }
    }
    
    private func showNetworkError(_ error: Error) {
        isShowingError = true
        
        if let networkError = error as? NetworkError {
            activeError = networkError
        } else {
            activeError = NetworkError.unexpectedError
        }
    }
}
