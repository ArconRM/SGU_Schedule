//
//  GroupsViewModelWithParsingSGU.swift
//  SGU_Schedule
//
//  Created by Артемий on 14.10.2023.
//

import Foundation

final class GroupsViewModelWithParsingSGU: GroupsViewModel {
    private let selectedAcademicProgramKey = "selectedAcademicProgram"
    private let selectedYearKey = "selectedYear"
    
    @Published var groupsWithoutFavorite = [GroupDTO]()
    
    @Published var isLoadingGroups: Bool = true
    @Published var isLoadingFavoriteGroup: Bool = true
    
    @Published var isShowingError = false
    @Published var activeError: LocalizedError?
    
    var favoriteGroupNumber: Int? {
        let number = UserDefaults.standard.integer(forKey: ViewModelsKeys.favoriteGroupNumberKey.rawValue)
        return number != 0 ? number : nil
    }
    
    @Published var networkManager: GroupNetworkManager
    
    init() {
        self.networkManager = GroupNetworkManagerWithParsing(urlSource: URLSourceSGU(),
                                                             groupsParser: GroupsHTMLParserSGU())
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
    
    public func setSelectedAcademicProgramAndFetchGroups(newValue: AcademicProgram, isOnline: Bool) {
        UserDefaults.standard.set(newValue.rawValue, forKey: selectedAcademicProgramKey)
        fetchGroupsWithoutFavorite(year: getSelectedYear(), academicProgram: newValue, isOnline: isOnline)
    }
    
    public func setSelectedYearAndFetchGroups(newValue: Int, isOnline: Bool) {
        UserDefaults.standard.set(newValue, forKey: selectedYearKey)
        fetchGroupsWithoutFavorite(year: newValue, academicProgram: getSelectedAcademicProgram(), isOnline: isOnline)
    }
    
    public func fetchGroupsWithoutFavorite(year: Int, academicProgram: AcademicProgram, isOnline: Bool) {
        self.isLoadingGroups = true
        
        if isOnline {
            networkManager.getGroupsByYearAndAcademicProgram(year: year, program: academicProgram, resultQueue: .main) { result in
                switch result {
                case .success(let groups):
                    if self.favoriteGroupNumber != nil {
                        self.groupsWithoutFavorite = groups.filter { $0.fullNumber != self.favoriteGroupNumber! }
                    } else {
                        self.groupsWithoutFavorite = groups
                    }
                case .failure(let error):
                    self.groupsWithoutFavorite = []
                    self.showNetworkError(error: error)
                }
                self.isLoadingGroups = false
            }
        } else {
            self.isLoadingGroups = false
        }
        
    }
    
    private func showNetworkError(error: Error) {
        self.isShowingError = true
        
        if let networkError = error as? NetworkError {
            self.activeError = networkError
        } else {
            self.activeError = NetworkError.unexpectedError
        }
    }
}
