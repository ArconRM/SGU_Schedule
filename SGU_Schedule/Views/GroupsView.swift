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
    
    @State private var selectedAcademicProgram = AcademicProgram.Masters
    @State private var selectedYear = 1
    
    @State var selectedDepartment: DepartmentDTO
    
    @State private var showSettingsSideMenuView: Bool = false
    @State var showTutorialView: Bool = false
    
    var body: some View {
        ZStack {
            if UIDevice.isPhone {
                LinearGradient(
                    colors: [ AppTheme(rawValue: appSettings.currentAppTheme)!.backgroundColor(colorScheme: colorScheme), (colorScheme == .light ? .white : .black)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .blur(radius: 2)
                .ignoresSafeArea()
            } else if UIDevice.isPad {
                AppTheme(rawValue: appSettings.currentAppTheme)?.backgroundColor(colorScheme: colorScheme)
                    .ignoresSafeArea()
            }
            
            if showSettingsSideMenuView {
                SettingsSideMenuView(
                    selectedDepartment: selectedDepartment, 
                    selectedTheme: AppTheme(rawValue: appSettings.currentAppTheme)!,
                    selectedStyle: AppStyle(rawValue: appSettings.currentAppStyle)!,
                    selectedParser: viewsManager.isNewParserUsed ? .New : .Old,
                    showTutorial: $showTutorialView
                )
                    .environmentObject(appSettings)
            }
            
            VStack {
                // Пикеры с программой обучения и курсом
                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation(.bouncy(duration: 0.5)) {
                            showSettingsSideMenuView.toggle()
                        }
                    }) {
                        Image(systemName: "gear")
                            .font(.system(size: 30, weight: .semibold))
                            .padding(5)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .background (
                                ZStack {
                                    (colorScheme == .light ? Color.white : Color.gray.opacity(0.4))
                                        .cornerRadius(5)
                                        .blur(radius: 2)
                                }
                                    .background(
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(colorScheme == .light ? .white : .clear)
                                            .shadow(color: colorScheme == .light ? .gray.opacity(0.7) : .white.opacity(0.2), radius: 4)
                                    )
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing, -5)
                            .offset(x: 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
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
                            HStack {
                                Text(selectedAcademicProgram.rawValue)
                                    .bold()
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                                    .padding(15)
                                    .background (
                                        ZStack {
                                            (colorScheme == .light ? Color.white : Color.gray.opacity(0.4))
                                                .cornerRadius(15)
                                                .blur(radius: 2)
                                                .ignoresSafeArea()
                                        }
                                            .background(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(colorScheme == .light ? .white : .clear)
                                                    .shadow(color: colorScheme == .light ? .gray.opacity(0.4) : .white.opacity(0.2), radius: 6)))
                            }
                        }
                        .frame(minWidth: 300)
                        .onChange(of: selectedAcademicProgram) { newValue in
                            viewModel.setSelectedAcademicProgramAndFetchGroups(
                                newValue: newValue,
                                isOnline: networkMonitor.isConnected
                            )
                        }
                    }
                    
                    Spacer()
                        .frame(maxWidth: .infinity, alignment: .trailing)
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
                        HStack{
                            Text(String(selectedYear) + " курс")
                                .bold()
                                .foregroundColor(colorScheme == .light ? .black : .white)
                                .padding(.vertical, 11)
                                .padding(.horizontal, 25)
                                .background (
                                    ZStack {
                                        (colorScheme == .light ? Color.white : Color.gray.opacity(0.4))
                                            .cornerRadius(15)
                                            .blur(radius: 2)
                                            .ignoresSafeArea()
                                    }
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(colorScheme == .light ? .white : .clear)
                                                .shadow(color: colorScheme == .light ? .gray.opacity(0.4) : .white.opacity(0.2), radius: 6)))
                        }
                    }
                    .onChange(of: selectedYear) { newValue in
                        viewModel.setSelectedYearAndFetchGroups(
                            newValue: newValue,
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
                                viewsManager.selectGroup(fullNumber: viewModel.favouriteGroup!.fullNumber, isFavourite: true, isPinned: false)
                                viewsManager.showScheduleView()
                            }
                        } label: {
                            GroupSubview(group: AcademicGroupDTO(fullNumber: viewModel.favouriteGroup!.fullNumber, departmentCode: selectedDepartment.code), isFavourite: true, isPinned: false)
                                .environmentObject(appSettings)
                        }
                    }
                    
                    if !viewModel.savedGroupsWithoutFavourite.isEmpty {
                        ForEach(viewModel.savedGroupsWithoutFavourite, id:\.self) { group in
                            Button {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    viewsManager.selectGroup(fullNumber: group.fullNumber, isFavourite: false, isPinned: true)
                                    viewsManager.showScheduleView()
                                }
                            } label: {
                                GroupSubview(group: AcademicGroupDTO(fullNumber: group.fullNumber, departmentCode: selectedDepartment.code), isFavourite: false, isPinned: true)
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
                                        viewsManager.selectGroup(fullNumber: group.fullNumber, isFavourite: false, isPinned: false)
                                        viewsManager.showScheduleView()
                                    }
                                } label: {
                                    GroupSubview(group: group, isFavourite: false, isPinned: false)
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
            isOnline: networkMonitor.isConnected
        )
    }
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView(viewModel: ViewModelWithParsingSGUFactory().buildGroupsViewModel(department: DepartmentDTO(fullName: "КНИИТ", code: "kn1t")), selectedDepartment: DepartmentDTO(fullName: "knt", code: "knt"))
    }
}
