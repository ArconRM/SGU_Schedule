//
//  GroupsViewModel.swift
//  SGU_Schedule
//
//  Created by Артемий on 14.10.2023.
//

import Foundation

public protocol GroupsViewModel: ObservableObject {
    var groups: [Group] { get set }
    
    var isLoadingGroups: Bool { get set }
    
    func getSelectedAcademicProgram() -> AcademicProgram
    func setSelectedAcademicProgramAndFetchGroups(newValue: AcademicProgram)
    
    func getSelectedYear() -> Int
    func setSelectedYearAndFetchGroups(newValue: Int)
    
    func fetchGroupsWithFavoritesBeingFirst(year: Int, academicProgram: AcademicProgram)
}
