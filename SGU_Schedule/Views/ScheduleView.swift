//
//  ScheduleView.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import SwiftUI
import UIKit

//ToDo: По башке бы понадавать за !
struct ScheduleView<ViewModel>: View, Equatable where ViewModel: ScheduleViewModel {
    static func == (lhs: ScheduleView<ViewModel>, rhs: ScheduleView<ViewModel>) -> Bool {
        return lhs.colorScheme == rhs.colorScheme
    }
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewsManager: ViewsManager
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @ObservedObject var viewModel: ViewModel
    
    var selectedGroup: GroupDTO?
    
    @State var favoriteGroupNumber: Int? = nil
    
    var body : some View {
        if selectedGroup == nil {
            Text("Ошибка при выборе группы")
                .font(.system(size: 30, weight: .bold))
                .padding(.top, -30)
        } else {
            NavigationView {
                ZStack {
                    ScheduleBackView(viewModel: viewModel, selectedGroup: selectedGroup!)
                    
                    CarouselView(pageCount: 2, currentIndex: 0, content: {
                        ScheduleModalView(viewModel: viewModel)
                            .environmentObject(networkMonitor)
                        
                        SessionEventsModalView(viewModel: viewModel)
                            .environmentObject(networkMonitor)
                    })
                }
                .onAppear {
                    viewModel.fetchUpdateDateAndSchedule(groupNumber: selectedGroup!.fullNumber,
                                                         isOnline: networkMonitor.isConnected)
                    
                    viewModel.fetchSessionEvents(groupNumber: selectedGroup!.fullNumber,
                                                 isOnline: networkMonitor.isConnected)
                    
                    favoriteGroupNumber = viewModel.favoriteGroupNumber
                }
                
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            
                            withAnimation(.easeInOut(duration: 0.5)) {
                                viewsManager.showGroupsView()
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
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            if viewModel.favoriteGroupNumber != selectedGroup!.fullNumber {
                                viewModel.favoriteGroupNumber = selectedGroup!.fullNumber
                                favoriteGroupNumber = viewModel.favoriteGroupNumber
                                
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    viewsManager.showGroupsView()
                                }
                            }
                        }) {
                            Image(systemName: favoriteGroupNumber == selectedGroup!.fullNumber ? "star.fill" : "star")
                                .font(.system(size: 18, weight: .semibold))
                                .padding(5)
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
                        }
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
                .alert(isPresented: $viewModel.isShowingError) {
                    Alert(title: Text(viewModel.activeError?.errorDescription ?? "Error"),
                          message: Text(viewModel.activeError?.failureReason ?? "Unknown"))
                }
            }
        }
    }
}


struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(viewModel: ScheduleViewModelWithParsingSGU(), selectedGroup: GroupDTO(fullNumber: 141))
            .environmentObject(NetworkMonitor())
            .environmentObject(ViewsManager())
    }
}
