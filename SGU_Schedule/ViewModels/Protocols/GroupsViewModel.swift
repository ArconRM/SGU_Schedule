//
//  GroupsViewModel.swift
//  SGU_Schedule
//
//  Created by Артемий on 14.10.2023.
//

import Foundation

public protocol GroupsViewModel: ObservableObject {
    var groups: [GroupDTO] { get set }
    
    var favoriteGroupNumber: Int? { get }
    
    var isLoadingGroups: Bool { get set }
    
    func getSelectedAcademicProgram() -> AcademicProgram
    func setSelectedAcademicProgramAndFetchGroups(newValue: AcademicProgram)
    
    func getSelectedYear() -> Int
    func setSelectedYearAndFetchGroups(newValue: Int)
    
    func fetchGroupsWithFavoritesBeingFirst(year: Int, academicProgram: AcademicProgram)
}
