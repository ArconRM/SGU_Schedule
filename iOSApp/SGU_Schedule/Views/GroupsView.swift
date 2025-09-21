//
//  GroupsView.swift
//  SGU_Schedule
//
//  Created by Артемий on 20.09.2023.
//

import SwiftUI
import SguParser

// TODO: .contentShape(Rectangle()) для ios 18, без него не работает tapGesture
struct GroupsView<ViewModel>: View where ViewModel: GroupsViewModel {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
    @EnvironmentObject var appearanceSettings: AppearanceSettingsStore

    @ObservedObject var viewModel: ViewModel

    @State private var selectedAcademicProgram: AcademicProgram
    @State private var selectedYear: Int
    @State private var selectedDepartment: DepartmentDTO
    @State private var isShowingSettingsView: Bool = false

    @State private var showAlert: Bool = false
    @State private var programTappedCount: Int = 0
    @State private var yearTappedCount: Int = 0

    init(viewModel: ViewModel, selectedDepartment: DepartmentDTO) {
        self.viewModel = viewModel
        self.selectedDepartment = selectedDepartment

        selectedYear = viewModel.getSelectedYear()
        selectedAcademicProgram = viewModel.getSelectedAcademicProgram()
    }

    var body: some View {
        ZStack {
            // Фон
            if UIDevice.isPhone {
                LinearGradient(
                    colors: [appearanceSettings.currentAppTheme.mainGradientColor(colorScheme: colorScheme),
                             appearanceSettings.currentAppTheme.pairedGradientColor(colorScheme: colorScheme)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .blur(radius: 2)
                .overlay {
                    if appearanceSettings.currentAppTheme == .pinkHelloKitty && !isShowingSettingsView {
                        Image("patternImageRofl")
                            .resizable()
                            .ignoresSafeArea()
                            .scaledToFill()
                            .clipped()
                            .opacity(colorScheme == .light ? 0.4 : 0.1)
                    }
                }
                .ignoresSafeArea()

            } else if UIDevice.isPad {
                if #unavailable(iOS 26) {
                    appearanceSettings.currentAppTheme.backgroundColor(colorScheme: colorScheme)
                        .overlay {
                            if appearanceSettings.currentAppTheme == .pinkHelloKitty && !isShowingSettingsView {
                                Image("patternImageRofl")
                                    .resizable()
                                    .ignoresSafeArea()
                                    .scaledToFill()
                                    .clipped()
                                    .opacity(colorScheme == .light ? 0.4 : 0.1)
                            }
                        }
                        .ignoresSafeArea()
                }
            }

            if isShowingSettingsView && UIDevice.isPhone {
                viewsManager.buildSettingsView()
                    .environmentObject(appearanceSettings)
                    .padding(safeAreaInsets)
            }

            // Группы
            VStack {
                if UIDevice.isPhone {
                    HStack(spacing: 0) {
                        makeShowSettingsButton()

                        Spacer()

                        if networkMonitor.isConnected {
                            makeAcademicProgramMenu()
                        }

                        Spacer()

                        makeShowTeachersSearchButton()

                    }
                    .padding(safeAreaInsets)
                } else if UIDevice.isPad {
                    if networkMonitor.isConnected {
                        makeAcademicProgramMenu()
                            .padding(safeAreaInsets)
                    }
                }

                if networkMonitor.isConnected {
                    makeYearMenu()
                }

                if !networkMonitor.isConnected {
                    Spacer()

                    Text("Нет соединения с интернетом")
                        .padding(.top)
                        .font(.system(size: 19, weight: .bold, design: .rounded))

                    Spacer()
                }

                // Список групп
                ScrollView {
                    Spacer()
                        .frame(height: 10)

                    if viewModel.favouriteGroup != nil {
                        Button {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                viewsManager.selectGroup(group: viewModel.favouriteGroup!, isFavourite: true, isPinned: false)
                                viewsManager.showScheduleView()
                            }
                        } label: {
                            GroupSubview(
                                group: viewModel.favouriteGroup!,
                                isFavourite: true,
                                isPinned: false,
                                differentDepartment: {
                                    if viewModel.favouriteGroup!.departmentCode != selectedDepartment.code {
                                        return DepartmentDTO(code: viewModel.favouriteGroup!.departmentCode)
                                    }
                                    return nil
                                }()
                            )
                            .environmentObject(appearanceSettings)
                        }
                    }

                    if !viewModel.savedGroupsWithoutFavourite.isEmpty {
                        ForEach(viewModel.savedGroupsWithoutFavourite, id: \.self) { group in
                            Button {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    viewsManager.selectGroup(group: group, isFavourite: false, isPinned: true)
                                    viewsManager.showScheduleView()
                                }
                            } label: {
                                GroupSubview(
                                    group: group,
                                    isFavourite: false,
                                    isPinned: true,
                                    differentDepartment: {
                                        if group.departmentCode != selectedDepartment.code {
                                            return DepartmentDTO(code: group.departmentCode)
                                        }
                                        return nil
                                    }()
                                )
                                .environmentObject(appearanceSettings)
                            }
                        }
                    }

                    if networkMonitor.isConnected {
                        if viewModel.isLoadingGroups {
                            Spacer()

                            Text("Загрузка...")
                                .padding(.top)
                                .font(.system(size: 19, weight: .bold))

                            Spacer()
                        } else {
                            ForEach(viewModel.groupsWithoutSaved, id: \.self) { group in
                                Button {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        viewsManager.selectGroup(group: group, isFavourite: false, isPinned: false)
                                        viewsManager.showScheduleView()
                                    }
                                } label: {
                                    GroupSubview(
                                        group: group,
                                        isFavourite: false,
                                        isPinned: false
                                    )
                                    .environmentObject(appearanceSettings)
                                }
                            }
                        }
                    }
                    Spacer(minLength: 40)
                }
                .contentShape(Rectangle())
            }
            .cornerRadius(isShowingSettingsView && UIDevice.isPhone ? 20 : 0)
            .offset(x: isShowingSettingsView && UIDevice.isPhone ? 235 : 0, y: isShowingSettingsView && UIDevice.isPhone ? 100 : 0)
            .scaleEffect(isShowingSettingsView && UIDevice.isPhone ? 0.8 : 1)
            .disabled(isShowingSettingsView && UIDevice.isPhone)
            .onTapGesture {
                if isShowingSettingsView && UIDevice.isPhone {
                    viewsManager.showGroupsView()
                }
            }
            .onReceive(viewsManager.isShowingSettingsViewPublisher) { isShown in
                withAnimation(.bouncy(duration: 0.5)) {
                    self.isShowingSettingsView = isShown
                }
            }

            .alert(isPresented: $viewsManager.isShowingError) {
                Alert(title: Text(viewsManager.activeError?.errorDescription ?? "Error"),
                      message: Text(viewsManager.activeError?.failureReason ?? "Unknown"))
            }

            if showAlert {
                HeheAlert(show: $showAlert)
            }
        }
        .ignoresSafeArea()
        .accentColor(colorScheme == .light ? .black : .white)
        .onAppear {
            fetchAllData()
        }
        .onChange(of: viewsManager.needToReloadGroupView) { newValue in
            if newValue {
                fetchAllData()
            }
            viewsManager.needToReloadGroupView = false
        }

        .alert(isPresented: $viewModel.isShowingError) {
            Alert(title: Text(viewModel.activeError?.errorDescription ?? "Error"),
                  message: Text(viewModel.activeError?.failureReason ?? "Unknown"))
        }
    }

    private func makeShowSettingsButton() -> some View {
        Button(action: {
            withAnimation(.bouncy(duration: 0.5)) {
                viewsManager.showSettingsView()
            }

            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }) {
            MainButton {
                Image(systemName: "gear")
                    .padding(5)
                    .font(.system(size: 30, weight: .semibold))
            }
        }
        .padding(.leading)
    }

    private func makeShowTeachersSearchButton() -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                viewsManager.showTeachersSearchView()
            }

            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }) {
            MainButton {
                Image(systemName: "magnifyingglass")
                    .padding(5)
                    .font(.system(size: 30, weight: .semibold))
            }
        }
        .padding(.trailing)
    }

    private func makeAcademicProgramMenu() -> some View {
        Menu {
            Picker(selection: $selectedAcademicProgram) {
                ForEach(AcademicProgram.allCases, id: \.self) { program in
                    Text(program.rawValue)
                        .tag(program)
                        .font(.system(size: 15, weight: .bold))
                }
            } label: {}
        } label: {
            MainButton {
                Text(selectedAcademicProgram.rawValue)
                    .padding(14)
                    .font(.system(size: 17, weight: .bold))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            programTappedCount += 1
            if programTappedCount > 7 {
                withAnimation(.easeIn(duration: 0.2)) {
                    showAlert.toggle()
                }
                programTappedCount = 0
            }
        }
        .onChange(of: selectedAcademicProgram) { newValue in
            viewModel.setSelectedAcademicProgramAndFetchGroups(
                newValue: newValue,
                selectedDepartment: selectedDepartment,
                isOnline: networkMonitor.isConnected
            )
        }
    }

    private func makeYearMenu() -> some View {
        Menu {
            Picker(selection: $selectedYear) {
                ForEach(1..<7) {
                    Text("\($0) курс")
                        .tag($0)
                }
            } label: {}
        } label: {
            MainButton {
                Text(String(selectedYear) + " курс")
                    .padding(14)
                    .font(.system(size: 17, weight: .bold))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            yearTappedCount += 1
            if yearTappedCount > 7 {
                withAnimation(.easeIn(duration: 0.2)) {
                    showAlert.toggle()
                }
                yearTappedCount = 0
            }
        }
        .onChange(of: selectedYear) { newValue in
            viewModel.setSelectedYearAndFetchGroups(
                newValue: newValue,
                selectedDepartment: selectedDepartment,
                isOnline: networkMonitor.isConnected
            )
        }
    }

    private func fetchAllData() {
        viewModel.fetchGroups(
            year: selectedYear,
            academicProgram: selectedAcademicProgram,
            selectedDepartment: selectedDepartment,
            isOnline: networkMonitor.isConnected
        )
    }
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView(viewModel: ViewModelWithMockDataFactory().buildGroupsViewModel(department: DepartmentDTO.mock), selectedDepartment: DepartmentDTO.mock)
            .environmentObject(NetworkMonitor())
            .environmentObject(ViewsManagerWithMockDataFactory().makeViewsManager())
            .environmentObject(AppearanceSettingsStore())
    }
}
