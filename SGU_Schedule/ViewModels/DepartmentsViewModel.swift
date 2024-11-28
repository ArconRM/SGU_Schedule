//
//  DepartmentsViewModel.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 08.06.2024.
//

import Foundation

public class DepartmentsViewModel: ObservableObject {

    @Published var departments: [Department] = []

    @Published var isLoadingDepartments: Bool = true

    public func fetchDepartments() {
        self.departments = DepartmentSource.allCases.map { Department(code: $0.rawValue) }
        self.isLoadingDepartments = false
    }
}
