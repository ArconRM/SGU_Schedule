//
//  GroupsView.swift
//  SGU_Schedule
//
//  Created by Артемий on 20.09.2023.
//

import SwiftUI

//TODO: .contentShape(Rectangle()) для ios 18, без него не работает tapGesture
struct GroupsView<ViewModel>: View where ViewModel: GroupsViewModel {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
    @EnvironmentObject var appSettings: AppSettings
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var selectedAcademicProgram = AcademicProgram.BachelorAndSpeciality
    @State private var selectedYear = 1
    @State var selectedDepartment: Department
    
    @State private var showAlert: Bool = false
    @State private var programTappedCount: Int = 0
    @State private var yearTappedCount: Int = 0
    
    var body: some View {
        ZStack {
            // Фон
            if UIDevice.isPhone {
                LinearGradient(
                    colors: [appSettings.currentAppTheme.backgroundColor(colorScheme: colorScheme), (colorScheme == .light ? .white : .black)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .blur(radius: 2)
                .ignoresSafeArea()
                
            } else if UIDevice.isPad {
                appSettings.currentAppTheme.backgroundColor(colorScheme: colorScheme)
                    .ignoresSafeArea()
                
            }
            
            if viewsManager.isShowingSettingsView && UIDevice.isPhone {
                viewsManager.buildSettingsView()
                    .environmentObject(appSettings)
            }
            
            // Группы
            VStack {
                if UIDevice.isPhone {
                    HStack(spacing: 0) {
                        makeShowSettingsButton()
                        
                        Spacer()
                        
                        if networkMonitor.isConnected {
                            makeAcademicProgramMenu()
                                .offset(x: -33)
                        }
                        
                        Spacer()
                    }
                } else if UIDevice.isPad {
                    if networkMonitor.isConnected {
                        makeAcademicProgramMenu()
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
                                        return Department(code: viewModel.favouriteGroup!.departmentCode)
                                    }
                                    return nil
                                }()
                            )
                            .environmentObject(appSettings)
                        }
                    }
                    
                    if !viewModel.savedGroupsWithoutFavourite.isEmpty {
                        ForEach(viewModel.savedGroupsWithoutFavourite, id:\.self) { group in
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
                                            return Department(code: group.departmentCode)
                                        }
                                        return nil
                                    }()
                                )
                                .environmentObject(appSettings)
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
                            ForEach(viewModel.groupsWithoutSaved, id:\.self) { group in
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
                                    .environmentObject(appSettings)
                                }
                            }
                        }
                    }
                    Spacer(minLength: 40)
                }
                .contentShape(Rectangle())
            }
            .cornerRadius(viewsManager.isShowingSettingsView && UIDevice.isPhone ? 20 : 0)
            .offset(x: viewsManager.isShowingSettingsView && UIDevice.isPhone ? 235 : 0, y: viewsManager.isShowingSettingsView && UIDevice.isPhone ? 100 : 0)
            .scaleEffect(viewsManager.isShowingSettingsView && UIDevice.isPhone ? 0.8 : 1)
            .disabled(viewsManager.isShowingSettingsView && UIDevice.isPhone)
            .onTapGesture {
                if viewsManager.isShowingSettingsView && UIDevice.isPhone {
                    withAnimation(.bouncy(duration: 0.5)) {
                        viewsManager.showGroupsView()
                    }
                }
            }
            
            if showAlert {
                HeheAlert(show: $showAlert)
            }
        }
        .ignoresSafeArea(edges: [.bottom])
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
        .alert(isPresented: $viewsManager.isShowingError) {
            Alert(title: Text(viewsManager.activeError?.errorDescription ?? "Error"),
                  message: Text(viewsManager.activeError?.failureReason ?? "Unknown"))
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
    
    private func makeAcademicProgramMenu() -> some View {
        Menu {
            Picker(selection: $selectedAcademicProgram) {
                ForEach(AcademicProgram.allCases, id:\.self) { program in
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
        selectedYear = viewModel.getSelectedYear()
        selectedAcademicProgram = viewModel.getSelectedAcademicProgram()
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
        GroupsView(viewModel: ViewModelWithParsingSGUFactory().buildGroupsViewModel(department: Department.mock), selectedDepartment: Department.mock)
            .environmentObject(NetworkMonitor())
            .environmentObject(ViewsManager(appSettings: AppSettings(), viewModelFactory: ViewModelWithParsingSGUFactory(), viewModelFactory_old: ViewModelWithParsingSGUFactory_old(), schedulePersistenceManager: GroupScheduleCoreDataManager(), groupPersistenceManager: GroupCoreDataManager(), isOpenedFromWidget: false))
            .environmentObject(AppSettings())
    }
}
