//
//  GroupsViewModelWithParsingSGUAssembly.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

class GroupsViewModelWithParsingSGUAssembly: GroupsViewModelsAssembly {
    typealias ViewModel = GroupsViewModelWithParsingSGU
    
    func build() -> ViewModel {
        return GroupsViewModelWithParsingSGU(networkManager: GroupsNetworkManagerWithParsing(urlSource: URLSourceSGU(), groupsParser: GroupsHTMLParserSGU()))
    }
}
