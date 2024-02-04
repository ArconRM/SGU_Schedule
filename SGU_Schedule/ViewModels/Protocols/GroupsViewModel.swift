//
//  GroupsViewModel.swift
//  SGU_Schedule
//
//  Created by Артемий on 14.10.2023.
//

import Foundation

public protocol GroupsViewModel: ObservableObject {
    var groupsWithoutFavorite: [GroupDTO] { get set }
    var favoriteGroupNumber: Int? { get }
    
    var isLoadingGroups: Bool { get set }
    var isLoadingFavoriteGroup: Bool { get set }
    
    var isShowingError: Bool { get set }
    var activeError: LocalizedError? { get set }
    
    func getSelectedAcademicProgram() -> AcademicProgram
    func getSelectedYear() -> Int
    
    func setSelectedAcademicProgramAndFetchGroups(newValue: AcademicProgram, isOnline: Bool)
    func setSelectedYearAndFetchGroups(newValue: Int, isOnline: Bool)
    
    func fetchGroupsWithoutFavorite(year: Int, academicProgram: AcademicProgram, isOnline: Bool)
}
