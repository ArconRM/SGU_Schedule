//
//  GroupsInteractorImpl.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 20.04.2025.
//

import Foundation

struct GroupsInteractorImpl: GroupsInteractor {
    private let groupsNetworkManager: GroupsNetworkManager
    private let groupPersistenceManager: GroupPersistenceManager

    init(
        groupsNetworkManager: GroupsNetworkManager,
        groupPersistenceManager: GroupPersistenceManager
    ) {
        self.groupsNetworkManager = groupsNetworkManager
        self.groupPersistenceManager = groupPersistenceManager
    }

    func fetchFavouriteGroup(
        completionHandler: @escaping (Result<AcademicGroupDTO?, Error>) -> Void
    ) {
        do {
            let favouriteGroup = try groupPersistenceManager.getFavouriteGroupDTO()
            DispatchQueue.main.async {
                completionHandler(.success(favouriteGroup))
            }
        } catch let error {
            DispatchQueue.main.async {
                completionHandler(.failure(error))
            }
        }
    }

    func fetchSavedGroupsWithoutFavourite(
        completionHandler: @escaping (Result<[AcademicGroupDTO], Error>) -> Void
    ) {
        do {
            let savedGroupsWithoutFavourite = try groupPersistenceManager.fetchAllItemsDTO()
            DispatchQueue.main.async {
                completionHandler(.success(savedGroupsWithoutFavourite))
            }
        } catch let error {
            DispatchQueue.main.async {
                completionHandler(.failure(error))
            }
        }
    }

    func fetchNertworkGroups(
        year: Int,
        academicProgram: AcademicProgram,
        selectedDepartment: DepartmentDTO,
        isOnline: Bool,
        completionHandler: @escaping (Result<[AcademicGroupDTO], any Error>) -> Void
    ) {
        if isOnline {
            groupsNetworkManager.getGroupsByYearAndAcademicProgram(
                year: year,
                program: academicProgram,
                department: selectedDepartment,
                resultQueue: .main
            ) { result in
                switch result {
                case .success(let groups):
                    DispatchQueue.main.async {
                        completionHandler(.success(groups))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completionHandler(.failure(error))
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                completionHandler(.success([]))
            }
        }
    }

}
