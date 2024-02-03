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
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var selectedAcademicProgram = AcademicProgram.BachelorAndSpeciality
    @State private var selectedYear = 1
    @State private var favoriteGroupNumber: Int? = nil
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue.opacity(0.15), (colorScheme == .light ? .white : .black)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .blur(radius: 2)
            .ignoresSafeArea()
            
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
                                .padding(.vertical, 13)
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
                        viewModel.setSelectedYearAndFetchGroups(newValue: newValue)
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
                    if favoriteGroupNumber != nil {
                        Button {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                viewsManager.showScheduleView(selectedGroup: GroupDTO(fullNumber: favoriteGroupNumber!))
                            }
                        } label: {
                            GroupSubview(group: GroupDTO(fullNumber: favoriteGroupNumber!), isFavorite: true)
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
                            ForEach(viewModel.groupsWithoutFavorite, id:\.self) { group in
                                Button {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        viewsManager.showScheduleView(selectedGroup: group)
                                    }
                                } label: {
                                    GroupSubview(group: group, isFavorite: false)
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
            .environmentObject(NetworkMonitor())
            .environmentObject(ViewsManager())
    }
}
