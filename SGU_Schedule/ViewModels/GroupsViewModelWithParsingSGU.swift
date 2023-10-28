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
    
    @Published var groups = [GroupDTO]()
    @Published var isLoadingGroups: Bool = true
    
    var favoriteGroupNumber: Int? {
        get {
            let number = UserDefaults.standard.integer(forKey: GroupsKeys.favoriteGroupNumberKey.rawValue)
            return number != 0 ? number : nil
        }
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
    
    public func setSelectedAcademicProgramAndFetchGroups(newValue: AcademicProgram) {
        UserDefaults.standard.set(newValue.rawValue, forKey: selectedAcademicProgramKey)
        fetchGroupsWithFavoritesBeingFirst(year: getSelectedYear(), academicProgram: newValue)
    }
    
    
    public func getSelectedYear() -> Int {
        if UserDefaults.standard.value(forKey: selectedYearKey) == nil {
            UserDefaults.standard.set(1, forKey: selectedYearKey)
        }
        
        return UserDefaults.standard.integer(forKey: selectedYearKey)
    }
    
    public func setSelectedYearAndFetchGroups(newValue: Int) {
        UserDefaults.standard.set(newValue, forKey: selectedYearKey)
        fetchGroupsWithFavoritesBeingFirst(year: newValue, academicProgram: getSelectedAcademicProgram())
    }
    
    
    public func fetchGroupsWithFavoritesBeingFirst(year: Int, academicProgram: AcademicProgram) {
        
        networkManager.getGroupsByYearAndAcademicProgram(year: year, program: academicProgram, resultQueue: .main) { result in
            switch result {
            case .success(let groups):
                if self.favoriteGroupNumber != nil, let favGroup = groups.first(where: { $0.fullNumber == self.favoriteGroupNumber }) {
                    self.groups = [favGroup] + groups.filter { $0.fullNumber != self.favoriteGroupNumber }
                } else {
                    self.groups = groups
                }
            case .failure(let error):
                self.groups = []
                print(error)
            }
            self.isLoadingGroups = false
        }
    }
}
