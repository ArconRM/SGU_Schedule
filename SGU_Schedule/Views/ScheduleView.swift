//
//  ScheduleView.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import SwiftUI
import UIKit

//TODO: По башке бы понадавать за !
struct ScheduleView<ViewModel>: View, Equatable where ViewModel: ScheduleViewModel {
    //чтобы не вью не переебашивалось при смене темы (и также источника инета)
    static func == (lhs: ScheduleView<ViewModel>, rhs: ScheduleView<ViewModel>) -> Bool {
        return lhs.colorScheme == rhs.colorScheme
    }
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
    @EnvironmentObject var appSettings: AppSettings
    
    @ObservedObject var viewModel: ViewModel
    
    @State var selectedGroup: GroupDTO?
    
    @State var favoriteGroupNumber: Int? = nil
    
    var body : some View {
        if selectedGroup == nil {
            Text("Ошибка при выборе группы")
                .font(.system(size: 30, weight: .bold))
                .padding(.top, -30)
        } else if UIDevice.isPhone {
            NavigationView {
                buildUI()
            }
        } else if UIDevice.isPad {
            buildUI()
        }
    }
    
    private func buildUI() -> some View {
        ZStack {
            ScheduleBackView(viewModel: viewModel, selectedGroup: selectedGroup!)
            
            CarouselView(pageCount: 2, currentIndex: 0, content: {
                ScheduleModalView(viewModel: viewModel)
                    .environmentObject(networkMonitor)
                    .environmentObject(viewsManager)
                
                SessionEventsModalView(viewModel: viewModel)
                    .environmentObject(networkMonitor)
            })
        }
        .onAppear {
            fetchAllData()
        }
        
        .toolbar {
            makeCloseToolbarItem()
            
            makeFavoriteToolbar()
        }
        
        .edgesIgnoringSafeArea(.bottom)
        .alert(isPresented: $viewModel.isShowingError) {
            Alert(title: Text(viewModel.activeError?.errorDescription ?? "Error"),
                  message: Text(viewModel.activeError?.failureReason ?? "Unknown"))
        }
    }
    
    private func fetchAllData() {
        viewModel.fetchUpdateDateAndSchedule(groupNumber: selectedGroup!.fullNumber,
                                             isOnline: networkMonitor.isConnected)
        
        viewModel.fetchSessionEvents(groupNumber: selectedGroup!.fullNumber,
                                     isOnline: networkMonitor.isConnected)
        
        favoriteGroupNumber = viewModel.favoriteGroupNumber
    }
    
    private func makeCloseToolbarItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewsManager.showGroupsView(needToReload: false)
                }
            }) {
                Image(systemName: "multiply")
                    .font(.system(size: 23, weight: .semibold))
                    .padding(7)
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .background (
                        ZStack {
                            (colorScheme == .light ? Color.white : Color.gray.opacity(0.4))
                                .cornerRadius(5)
                                .blur(radius: 2)
                                .ignoresSafeArea()
                        }
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(colorScheme == .light ? .white : .clear)
                                    .shadow(color: colorScheme == .light ? .gray.opacity(0.7) : .white.opacity(0.2), radius: 4)))
                    .opacity(viewModel.isLoadingLessons ? 0.5 : 1)
            }
            .disabled(viewModel.isLoadingLessons)
        }
    }
    
    private func makeFavoriteToolbar() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                if viewModel.favoriteGroupNumber != selectedGroup!.fullNumber {
                    viewModel.favoriteGroupNumber = selectedGroup!.fullNumber
                    favoriteGroupNumber = viewModel.favoriteGroupNumber
                    
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewsManager.showGroupsView(needToReload: UIDevice.isPad)
                    }
                }
            }) {
                Image(systemName: favoriteGroupNumber == selectedGroup!.fullNumber ? "star.fill" : "star")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(5)
                    .foregroundColor(AppTheme(rawValue: appSettings.currentAppTheme)!.foregroundColor(colorScheme: colorScheme))
                    .background (
                        ZStack {
                            (colorScheme == .light ? Color.white : Color.gray.opacity(0.4))
                                .cornerRadius(5)
                                .blur(radius: 2)
                                .ignoresSafeArea()
                        }
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(colorScheme == .light ? .white : .clear)
                                    .shadow(color: colorScheme == .light ? .gray.opacity(0.7) : .white.opacity(0.2), radius: 4)))
                    .opacity(viewModel.isLoadingLessons ? 0.5 : 1)
            }
            .disabled(viewModel.isLoadingLessons)
        }
    }
}


struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(viewModel: ViewModelWithParsingSGUFactory().buildScheduleViewModel(department: DepartmentDTO(fullName: "Test", code: "knt")),
                     selectedGroup: GroupDTO(fullNumber: 141))
        .environmentObject(NetworkMonitor())
        .environmentObject(ViewsManager(viewModelFactory: ViewModelWithParsingSGUFactory()))
    }
}
