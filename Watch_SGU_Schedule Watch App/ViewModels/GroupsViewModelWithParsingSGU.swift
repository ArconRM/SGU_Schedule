//
//  GroupsViewModelWithParsingSGU.swift
//  Watch_SGU_Schedule Watch App
//
//  Created by Артемий on 18.11.2023.
//

import Foundation

// ToDo: Error Handling
final class GroupsViewModelWithParsingSGU: GroupsViewModel {
    @Published var groups = [GroupDTO]()
    @Published var isLoadingGroups: Bool = true
    
    @Published var networkManager: GroupNetworkManager
    
    init() {
        self.networkManager = GroupNetworkManagerWithParsing(urlSource: URLSourceSGU(),
                                                             groupsParser: GroupsHTMLParserSGU())
    }
    
    public func fetchGroups(year: Int, academicProgram: AcademicProgram) {
        self.isLoadingGroups = true
        
        networkManager.getGroupsByYearAndAcademicProgram(year: year, program: academicProgram, resultQueue: .main) { result in
            switch result {
            case .success(let groups):
                self.groups = groups
                
            case .failure(let error):
                self.groups = []
                print(error)
            }
            self.isLoadingGroups = false
        }
    }
}
