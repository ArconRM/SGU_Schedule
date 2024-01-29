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
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var favoriteGroupNumber: Int? = nil
    
    @State private var selectedAcademicProgram = AcademicProgram.BachelorAndSpeciality
    @State private var selectedYear = 1
    
    var body: some View {
        NavigationView {
            ZStack {
                if colorScheme == .light {
                    LinearGradient(
                        colors: [.blue.opacity(0.15), .white],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .blur(radius: 2)
                    .ignoresSafeArea()
                } else {
                    LinearGradient(
                        colors: [.blue.opacity(0.15), .black],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .blur(radius: 2)
                    .ignoresSafeArea()
                }
                
                VStack {
                    // Пикеры с программой обучения и курсом
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
                            HStack{
                                Text(selectedAcademicProgram.rawValue)
                                    .bold()
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                                    .padding(.vertical, 5)
                            }
                        }
                        .onChange(of: selectedAcademicProgram) { newValue in
                            viewModel.setSelectedAcademicProgramAndFetchGroups(newValue: newValue)
                        }
                        
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
                            }
                        }
                        .onChange(of: selectedYear) { newValue in
                            viewModel.setSelectedYearAndFetchGroups(newValue: newValue)
                        }
                    }
                    
                    // Если в оффлайне
                    if !networkMonitor.isConnected {
                        Spacer()
                        
                        Text("Нет соединения с интернетом")
                            .padding(.top)
                            .font(.system(size: 19, weight: .bold, design: .rounded))
                        
                        Spacer()
                    }
                    
                    ScrollView {
                        // Сохраненная группа
                        if favoriteGroupNumber != nil {
                            NavigationLink(
                                destination: ScheduleView(viewModel: ScheduleViewModelWithParsingSGU(),
                                                          favoriteGroupNumber: $favoriteGroupNumber,
                                                          selectedGroup: GroupDTO(fullNumber: favoriteGroupNumber!))
                                .environmentObject(networkMonitor)
                            ) {
                                GroupSubview(group: GroupDTO(fullNumber: favoriteGroupNumber!),
                                             isFavorite: true)
                            }
                        }
                        
                        // Список групп
                        if networkMonitor.isConnected {
                            if viewModel.isLoadingGroups {
                                Spacer()
                                
                                Text("Загрузка...")
                                    .padding(.top)
                                    .font(.system(size: 19, weight: .bold))
                                
                                Spacer()
                            } else {                                ForEach(viewModel.groupsWithoutFavorite, id:\.self) { group in
                                NavigationLink(
                                    destination: ScheduleView(viewModel: ScheduleViewModelWithParsingSGU(), 
                                                              favoriteGroupNumber: $favoriteGroupNumber, 
                                                              selectedGroup: group)
                                    .environmentObject(networkMonitor)
                                ) {
                                    GroupSubview(group: group, 
                                                 isFavorite: false)
                                }
                            }
                            .background(.clear)
                            .onChange(of: favoriteGroupNumber) { _ in
                                viewModel.fetchGroupsWithoutFavorite(year: selectedYear, academicProgram: selectedAcademicProgram)
                            }
                            }
                        }
                    }
                }
            }
        }
        .accentColor(colorScheme == .light ? .black : .white)
        .onAppear {
            selectedYear = viewModel.getSelectedYear()
            selectedAcademicProgram = viewModel.getSelectedAcademicProgram()
            viewModel.fetchGroupsWithoutFavorite(year: selectedYear, academicProgram: selectedAcademicProgram)
            favoriteGroupNumber = viewModel.favoriteGroupNumber
        }
        .alert(isPresented: $viewModel.isShowingError) {
            Alert(title: Text(viewModel.activeError?.errorDescription ?? "Error"),
                  message: Text(viewModel.activeError?.failureReason ?? "Unknown"))
        }
    }
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView(viewModel: GroupsViewModelWithParsingSGU())
            .colorScheme(.dark)
    }
}
