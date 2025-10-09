//
//  DepartmentsView.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 08.06.2024.
//

import SwiftUI

struct DepartmentsView<ViewModel>: View where ViewModel: DepartmentsViewModel {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
    @EnvironmentObject var appearanceSettings: AppearanceSettingsStore

    @StateObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            appearanceSettings.currentAppTheme.backgroundColor(colorScheme: colorScheme)
                .ignoresSafeArea()
                .shadow(radius: 5)

            if self.viewModel.isLoadingDepartments {
                ProgressView()
            } else {
            ScrollView {
                ForEach(viewModel.departments, id: \.self) { department in
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            viewsManager.selectDepartment(department: department)
                            viewsManager.showGroupsView()
                        }
                    } label: {
                        PlainTextSubview(text: department.fullName)
                    }
                }
            }
            }
        }
        .onAppear {
            self.viewModel.fetchDepartments()
        }
    }
}

#Preview {
    DepartmentsView(viewModel: ViewModelWithMockDataFactory().buildDepartmentsViewModel())
        .environmentObject(AppearanceSettingsStore())
}
