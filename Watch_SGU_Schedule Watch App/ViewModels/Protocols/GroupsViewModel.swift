//
//  GroupsViewModel.swift
//  Watch_SGU_Schedule Watch App
//
//  Created by Артемий on 18.11.2023.
//

import Foundation

public protocol GroupsViewModel: ObservableObject {
    var groups: [GroupDTO] { get set }
    
    var isLoadingGroups: Bool { get set }
    
    func fetchGroups(year: Int, academicProgram: AcademicProgram)
}
