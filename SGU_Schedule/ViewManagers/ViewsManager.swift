//
//  ViewsManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 01.02.2024.
//

import Foundation
import SwiftUI

// TODO: через DI с протоколом сделать
/// Manages navigation and passing data
public final class ViewsManager: ObservableObject {
    
    @Published private(set) var currentView: AppViews
    @Published private(set) var selectedGroup: GroupDTO? = nil
    @Published var showError: Bool = false
    
    init() {
        currentView = .GroupsView
    }
    
    func showScheduleView(selectedGroup: GroupDTO) {
        self.currentView = .ScheduleView
        self.selectedGroup = selectedGroup
    }
    
    func showGroupsView() {
        self.currentView = .GroupsView
    }
}

enum AppViews {
    case GroupsView
    case ScheduleView
}
