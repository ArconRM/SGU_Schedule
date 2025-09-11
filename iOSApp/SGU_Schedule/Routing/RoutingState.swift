//
//  RoutingState.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 16.04.2025.
//

import Foundation
import SguParser

final class RoutingState: ObservableObject {
    @Published var selectedGroup: AcademicGroupDTO?
    @Published var isSelectedGroupFavourite: Bool?
    @Published var isSelectedGroupPinned: Bool?

    @Published var currentView: AppViews = .departmentsView
    @Published var isShowingSettingsView: Bool = false

    @Published var selectedTeacherUrlEndpoint: String?
    @Published var selectedTeacherLessonsUrlEndpoint: String?
}
