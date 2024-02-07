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
    @Published var selectedGroup: GroupDTO? = nil
    
    //Для айпада, ибо оно само не обновляется
    var needToReloadGroupView: Bool = false
    
    @Published var showError: Bool = false
    
    init() {
        currentView = .GroupsView
    }
    
    func showScheduleView(selectedGroup: GroupDTO) {
        self.selectedGroup = selectedGroup
        self.currentView = .ScheduleView
    }
    
    func showGroupsView(needToReload: Bool) {
        self.needToReloadGroupView = needToReload
        self.currentView = .GroupsView
    }
}

enum AppViews {
    case GroupsView
    case ScheduleView
}
