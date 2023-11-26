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
                    
                    if networkMonitor.isConnected {
                        if viewModel.isLoadingGroups {
                            Spacer()
                            
                            Text("Загрузка...")
                                .padding(.top)
                                .font(.system(size: 19, weight: .bold))
                            
                            Spacer()
                        } else {
                            ScrollView {
                                ForEach(viewModel.groups, id:\.self) { group in
                                    NavigationLink(
                                        destination: ScheduleView(viewModel: ScheduleViewModelWithParsingSGU(), 
                                                                  selectedGroup: group,
                                                                  favoriteGroupNumber: $favoriteGroupNumber)
                                            .environmentObject(networkMonitor)
                                    ) {
                                        GroupSubview(group: group, isFavorite: favoriteGroupNumber == group.fullNumber)
                                    }
                                }
                            }
                            .background(.clear)
                            .onChange(of: favoriteGroupNumber) { _ in
                                viewModel.fetchGroupsWithFavoritesBeingFirst(year: selectedYear, academicProgram: selectedAcademicProgram)
                            }
                        }
                    } else if favoriteGroupNumber != nil {
                        Spacer()
                        
                        NavigationLink(
                            destination: ScheduleView(viewModel: ScheduleViewModelWithParsingSGU(), 
                                                      selectedGroup: GroupDTO(fullNumber: favoriteGroupNumber!),
                                                      favoriteGroupNumber: $favoriteGroupNumber)
                                .environmentObject(networkMonitor)
                        ) {
                            GroupSubview(group: GroupDTO(fullNumber: favoriteGroupNumber!),
                                         isFavorite: true)
                        }
                        
                        Spacer()
                    } else {
                        Spacer()
                        
                        Text("Нет соединения с интернетом")
                            .padding(.top)
                            .font(.system(size: 19, weight: .bold, design: .rounded))
                        
                        Spacer()
                    }
                }
            }
        }
        .accentColor(colorScheme == .light ? .black : .white)
        .onAppear {
            selectedYear = viewModel.getSelectedYear()
            selectedAcademicProgram = viewModel.getSelectedAcademicProgram()
            viewModel.fetchGroupsWithFavoritesBeingFirst(year: selectedYear, academicProgram: selectedAcademicProgram)
            favoriteGroupNumber = viewModel.favoriteGroupNumber
        }
    }
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView(viewModel: GroupsViewModelWithParsingSGU())
            .colorScheme(.dark)
    }
}
