//
//  DepartmentsView.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 08.06.2024.
//

import SwiftUI

struct DepartmentsView<ViewModel>: View, Equatable where ViewModel: DepartmentsViewModel {
    // чтобы не вью не переебашивалось при смене темы (и также источника инета)
    static func == (lhs: DepartmentsView<ViewModel>, rhs: DepartmentsView<ViewModel>) -> Bool {
        return lhs.colorScheme == rhs.colorScheme
    }

    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
    @EnvironmentObject var appearanceSettings: AppearanceSettingsStore

    @ObservedObject var viewModel: ViewModel

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
