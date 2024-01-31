//
//  ScheduleView.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import SwiftUI
import UIKit

struct ScheduleView<ViewModel>: View, Equatable where ViewModel: ScheduleViewModel {
    static func == (lhs: ScheduleView<ViewModel>, rhs: ScheduleView<ViewModel>) -> Bool {
        return lhs.colorScheme == rhs.colorScheme
    }
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @ObservedObject var viewModel: ViewModel
    
    @Binding var favoriteGroupNumber: Int?
    
    @State var selectedGroup: GroupDTO
    
    var body : some View {
        ZStack {
            ScheduleBackView(viewModel: viewModel, selectedGroup: selectedGroup)
            
            CarouselView(pageCount: 2, currentIndex: 0, content: {
                ScheduleModalView(viewModel: viewModel, selectedGroup: selectedGroup)
                    .environmentObject(networkMonitor)
                
                SessionEventsModalView(viewModel: viewModel, selectedGroup: selectedGroup)
                    .environmentObject(networkMonitor)
            })
        }
        .onAppear {
            viewModel.fetchUpdateDateAndSchedule(groupNumber: selectedGroup.fullNumber, isOnline: networkMonitor.isConnected)
            viewModel.fetchSessionEvents(groupNumber: selectedGroup.fullNumber, isOnline: networkMonitor.isConnected)
        }
        
        .toolbar {
            ToolbarItem {
                Button(action: {
                    if viewModel.favoriteGroupNumber != selectedGroup.fullNumber {
                        viewModel.favoriteGroupNumber = selectedGroup.fullNumber
                        favoriteGroupNumber = viewModel.favoriteGroupNumber
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Label("Добавить в избранное", systemImage: favoriteGroupNumber == selectedGroup.fullNumber ? "star.fill" : "star")
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


struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(viewModel: ScheduleViewModelWithParsingSGU(), 
                     favoriteGroupNumber: .constant(0),
                     selectedGroup: GroupDTO(fullNumber: 141))
        .environmentObject(NetworkMonitor())
//            .colorScheme(.dark)
    }
}
