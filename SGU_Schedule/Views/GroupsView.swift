//
//  GroupsView.swift
//  SGU_Schedule
//
//  Created by Артемий on 20.09.2023.
//

import SwiftUI

struct GroupsView<ViewModel>: View where ViewModel: GroupsViewModel {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
    @EnvironmentObject var appSettings: AppSettings
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var selectedAcademicProgram = AcademicProgram.BachelorAndSpeciality
    @State private var selectedYear = 1
    
    @State var selectedDepartment: DepartmentDTO
    
    @State private var showSettingsSideMenuView: Bool = false
    @State var showTutorialView: Bool = false
    
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
            
            // Настройки
            if showSettingsSideMenuView {
                SettingsSideMenuView(
                    selectedDepartment: selectedDepartment, 
                    selectedTheme: appSettings.currentAppTheme,
                    selectedStyle: appSettings.currentAppStyle,
                    selectedParser: viewsManager.isNewParserUsed ? .New : .Old,
                    showTutorial: $showTutorialView
                )
                    .environmentObject(appSettings)
                    .blur(radius: showTutorialView ? 3 : 0)
            }
            
            // Группы
            VStack {
                // Пикеры с программой обучения и курсом
                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation(.bouncy(duration: 0.5)) {
                            showSettingsSideMenuView.toggle()
                        }
                    }) {
                        MainButton {
                            Image(systemName: "gear")
                                .padding(5)
                                .font(.system(size: 30, weight: .semibold))
                        }
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    if networkMonitor.isConnected {
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
                        .offset(x: -33)
                        .onChange(of: selectedAcademicProgram) { newValue in
                            viewModel.setSelectedAcademicProgramAndFetchGroups(
                                newValue: newValue, 
                                selectedDepartment: selectedDepartment,
                                isOnline: networkMonitor.isConnected
                            )
                        }
                    }
                    
                    Spacer()
                }
                
                if networkMonitor.isConnected {
                    Menu {
                        Picker(selection: $selectedYear) {
                            ForEach(1..<7) {
                                Text("\($0) курс")
                                    .tag($0)
                            }
                        } label: {}
                    } label: {
                        HStack {
                            MainButton {
                                Text(String(selectedYear) + " курс")
                                    .padding(14)
                                    .font(.system(size: 17, weight: .bold))
                            }
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
                                        return DepartmentDTO(code: viewModel.favouriteGroup!.departmentCode)
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
                                            return DepartmentDTO(code: group.departmentCode)
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
            }
            .cornerRadius(showSettingsSideMenuView ? 20 : 0)
            .offset(x: showSettingsSideMenuView ? 235 : 0, y: showSettingsSideMenuView ? 100 : 0)
            .scaleEffect(showSettingsSideMenuView ? 0.8 : 1)
            .disabled(showSettingsSideMenuView)
            .blur(radius: showTutorialView ? 3 : 0)
            .onTapGesture {
                if showSettingsSideMenuView {
                    withAnimation(.bouncy(duration: 0.5)) {
                        showSettingsSideMenuView.toggle()
                    }
                }
            }
            
            if showTutorialView {
                TutorialView(isShowing: $showTutorialView)
            }
        }
        .ignoresSafeArea(edges: [.bottom])
        .accentColor(colorScheme == .light ? .black : .white)
        .onAppear {
            showTutorialView = !viewModel.wasLaunched
            fetchAllData()
        }
        
        //Для айпада
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
        GroupsView(viewModel: ViewModelWithParsingSGUFactory().buildGroupsViewModel(department: DepartmentDTO(code: "kn1t")), selectedDepartment: DepartmentDTO(code: "kn1t"))
            .environmentObject(NetworkMonitor())
            .environmentObject(ViewsManager(viewModelFactory: ViewModelWithParsingSGUFactory(), viewModelFactory_old: ViewModelWithParsingSGUFactory_old(), schedulePersistenceManager: GroupScheduleCoreDataManager(), groupPersistenceManager: GroupCoreDataManager(), isOpenedFromWidget: false))
            .environmentObject(AppSettings())
    }
}
