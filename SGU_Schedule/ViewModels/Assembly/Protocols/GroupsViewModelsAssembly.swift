//
//  GroupsViewModelsAssembly.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

public protocol GroupsViewModelsAssembly {
    associatedtype ViewModel where ViewModel: GroupsViewModel
    
    func build() -> ViewModel
}
