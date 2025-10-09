//
//  ScheduleView.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import SwiftUI
import UIKit
import WidgetKit
import SguParser

struct ScheduleView<ViewModel>: View where ViewModel: ScheduleViewModel {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.colorScheme) var colorScheme

    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
    @EnvironmentObject var appearanceSettings: AppearanceSettingsStore

    @StateObject var viewModel: ViewModel

    @State var group: AcademicGroupDTO?
    @State var isFavourite: Bool
    @State var isPinned: Bool

    @State var showSessionEventsView: Bool = false
    @State var showSubgroups: Bool = false

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
            ZStack {
                ScheduleBackView(viewModel: viewModel, selectedGroup: group!)

                CarouselView(pages: ["Занятия", "Экзамены"], currentIndex: showSessionEventsView ? 1 : 0, viewsAlignment: .bottom) {
                    ScheduleModalView(viewModel: viewModel)
                        .environmentObject(networkMonitor)
                        .environmentObject(viewsManager)

                    SessionEventsModalView(viewModel: viewModel)
                        .environmentObject(networkMonitor)
                }
            }
            .blur(radius: showSubgroups ? 3 : 0)
            
            (colorScheme == .light ? Color.gray.opacity(0.1) : Color.black.opacity(0.3))
                .ignoresSafeArea()
                .opacity(showSubgroups ? 1 : 0)

            if showSubgroups {
                SubgroupsView(viewModel: viewModel, isShowing: $showSubgroups)
                    .onChange(of: viewModel.subgroupsByLessons) {
                        WidgetCenter.shared.reloadAllTimelines()
                    }
            }
        }
        .edgesIgnoringSafeArea([.bottom])
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CloseButton {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewsManager.showGroupsView()
                    }
                }
                .opacity(showSubgroups ? 0 : 1)
//                .padding(.top, 5)
            }

            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    if isFavourite {
                        makeShowGroupsToolbarButton()
                    } else {
                        makePinToolbarButton()
                    }
                    makeFavoriteToolbarButton()
                }
                .opacity(showSubgroups ? 0 : 1)
//                .padding(.top, 5)
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
        viewModel.fetchSchedule(
            group: group!,
            isOnline: networkMonitor.isConnected,
            isSaved: isFavourite || isPinned,
            isFavourite: isFavourite
        )

        viewModel.fetchSessionEvents(
            group: group!,
            isOnline: networkMonitor.isConnected,
            isSaved: isFavourite || isPinned
        )
    }

    private func makeShowGroupsToolbarButton() -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                showSubgroups = true
            }
        }) {

            if #available(iOS 26, *) {
                Image(systemName: "person.3.fill")
                    .padding(8)
                    .foregroundColor(appearanceSettings.currentAppTheme.foregroundColor(colorScheme: colorScheme))
            } else {
                MainButton {
                    Image(systemName: "person.3.fill")
                        .padding(8)
                        .foregroundColor(appearanceSettings.currentAppTheme.foregroundColor(colorScheme: colorScheme))
                }
            }
        }
        .opacity(viewModel.isLoadingLessons ? 0.5 : 1)
        .disabled(viewModel.isLoadingLessons)
    }

    private func makeFavoriteToolbarButton() -> some View {
        Button(action: {
            if !isFavourite {
                if !isPinned {
                    viewsManager.saveGroup(group: group!)
                }
                viewsManager.setFavouriteGroup(group: group!)
                isFavourite = true
                viewModel.clearSubgroups()
                fetchAllData()
            }

            if UIDevice.isPad {
                viewsManager.showGroupsView(needToReload: true)
            }

            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
        }) {
            if #available(iOS 26, *) {
                Image(systemName: isFavourite ? "star.fill" : "star")
                    .padding(8)
                    .foregroundColor(appearanceSettings.currentAppTheme.foregroundColor(colorScheme: colorScheme))
            } else {
                MainButton {
                    Image(systemName: isFavourite ? "star.fill" : "star")
                        .padding(8)
                        .foregroundColor(appearanceSettings.currentAppTheme.foregroundColor(colorScheme: colorScheme))
                }
            }
        }
        .opacity(viewModel.isLoadingLessons ? 0.5 : 1)
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

            if UIDevice.isPad {
                viewsManager.showGroupsView(needToReload: true)
            }

            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()

        }) {

            if #available(iOS 26, *) {
                Image(systemName: isPinned ? "pin.fill" : "pin")
                    .padding(8)
                    .foregroundColor(appearanceSettings.currentAppTheme.foregroundColor(colorScheme: colorScheme))
            } else {
                MainButton {
                    Image(systemName: isPinned ? "pin.fill" : "pin")
                        .padding(8)
                        .foregroundColor(appearanceSettings.currentAppTheme.foregroundColor(colorScheme: colorScheme))
                }
            }
        }
        .opacity(viewModel.isLoadingLessons ? 0.5 : 1)
        .disabled(viewModel.isLoadingLessons)
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(
            viewModel: ViewModelWithMockDataFactory().buildScheduleViewModel(),
            group: AcademicGroupDTO.mock,
            isFavourite: false,
            isPinned: false
        )
        .environmentObject(AppearanceSettingsStore())
        .environmentObject(NetworkMonitor())
        .environmentObject(ViewsManagerWithMockDataFactory().makeViewsManager())
    }
}
