//
//  GroupsInteractor.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 20.04.2025.
//

import Foundation

protocol GroupsInteractor {
    func fetchFavouriteGroup(
        completionHandler: @escaping (Result<AcademicGroupDTO?, Error>) -> Void
    )

    func fetchSavedGroupsWithoutFavourite(
        completionHandler: @escaping (Result<[AcademicGroupDTO], Error>) -> Void
    )

    func fetchNertworkGroups(
        year: Int,
        academicProgram: AcademicProgram,
        selectedDepartment: DepartmentDTO,
        isOnline: Bool,
        completionHandler: @escaping (Result<[AcademicGroupDTO], Error>) -> Void
    )
}
