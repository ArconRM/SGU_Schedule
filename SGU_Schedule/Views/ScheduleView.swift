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
    
    @State var group: AcademicGroupDTO?
    @State var isFavourite: Bool
    @State var isPinned: Bool
    
    var body: some View {
        if group == nil {
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
            ScheduleBackView(viewModel: viewModel, selectedGroup: group!)
            
            CarouselView(pageCount: 2, pageTitles: ["Занятия", "Экзамены"], currentIndex: 0, content: {
                ScheduleModalView(viewModel: viewModel)
                    .environmentObject(networkMonitor)
                    .environmentObject(viewsManager)
                
                SessionEventsModalView(viewModel: viewModel)
                    .environmentObject(networkMonitor)
            })
        }
        .edgesIgnoringSafeArea(.bottom)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                makeCloseToolbarButton()
                    .padding(.top, 5)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    if !isFavourite {
                        makePinToolbarButton()
                    }
                    makeFavoriteToolbarButton()
                }
                .padding(.top, 5)
            }
        }
        .onAppear {
            fetchAllData()
        }
        .alert(isPresented: $viewModel.isShowingError) {
            Alert(title: Text(viewModel.activeError?.errorDescription ?? "Error"),
                  message: Text(viewModel.activeError?.failureReason ?? "Unknown"))
        }
    }
    
    private func fetchAllData() {
        viewModel.fetchSchedule(group: group!,
                                isOnline: networkMonitor.isConnected,
                                isSaved: isFavourite || isPinned)
        
        viewModel.fetchSessionEvents(group: group!,
                                     isOnline: networkMonitor.isConnected)
    }
    
    private func makeCloseToolbarButton() -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                viewsManager.showGroupsView()
            }
        }) {
            MainButton {
                Image(systemName: "multiply")
                    .padding(10)
                    .font(.system(size: 21, weight: .semibold))
            }
        }
    }
    
    private func makeFavoriteToolbarButton() -> some View {
        Button(action: {
            if !isFavourite {
                if !isPinned {
                    viewsManager.saveGroup(group: group!)
                }
                viewsManager.setFavouriteGroup(group: group!)
                isFavourite = true
                fetchAllData()
            }
            
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }) {
            MainButton {
                Image(systemName: isFavourite ? "star.fill" : "star")
                    .padding(8)
                    .foregroundColor(appSettings.currentAppTheme.foregroundColor(colorScheme: colorScheme))
            }
            .opacity(viewModel.isLoadingLessons ? 0.5 : 1)
        }
        .disabled(viewModel.isLoadingLessons)
    }
    
    private func makePinToolbarButton() -> some View {
        Button(action: {
            if isPinned {
                viewsManager.deleteGroupFromPersistence(group: group!)
                
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewsManager.showGroupsView(needToReload: UIDevice.isPad)
                }
            } else {
                viewsManager.saveGroup(group: group!)
                isPinned = true
                fetchAllData()
            }
            
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()

        }) {
            MainButton {
                Image(systemName: isPinned ? "pin.fill" : "pin")
                    .padding(8)
                    .foregroundColor(appSettings.currentAppTheme.foregroundColor(colorScheme: colorScheme))
            }
            .opacity(viewModel.isLoadingLessons ? 0.5 : 1)
        }
        .disabled(viewModel.isLoadingLessons)
    }
}


struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(
            viewModel: ViewModelWithParsingSGUFactory().buildScheduleViewModel(),
            group: AcademicGroupDTO(fullNumber: "141", departmentCode: "knt1"),
            isFavourite: false,
            isPinned: false
        )
        .environmentObject(AppSettings())
        .environmentObject(NetworkMonitor())
        .environmentObject(ViewsManager(appSettings: AppSettings(), viewModelFactory: ViewModelWithParsingSGUFactory(), viewModelFactory_old: ViewModelWithParsingSGUFactory_old(), schedulePersistenceManager: GroupScheduleCoreDataManager(), groupPersistenceManager: GroupCoreDataManager(), isOpenedFromWidget: false))
    }
}
