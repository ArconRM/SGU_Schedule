//
//  SessionEventsModalView.swift
//  SGU_Schedule
//
//  Created by Артемий on 29.01.2024.
//

import SwiftUI

struct SessionEventsModalView<ViewModel>: View where ViewModel: ScheduleViewModel {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var curHeight: CGFloat = UIScreen.screenHeight - 120
    private let minHeight: CGFloat = 250
    private let maxHeight: CGFloat = UIScreen.screenHeight - 130
    
    @State var selectedGroup: GroupDTO
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Capsule()
                        .opacity(0.3)
                        .frame(width: 40, height: 6)
                }
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .background (Color.white.opacity (0.00001))
                .gesture(dragGesture)
                
                if networkMonitor.isConnected {
                    if viewModel.isLoadingSessionEvents {
                        Text("Загрузка...")
                            .padding(.top, -10)
                            .font(.system(size: 19, weight: .bold, design: .rounded))
                    } else if viewModel.sessionEvents != nil {
                        ScrollView {
                            ForEach(viewModel.sessionEvents!.sessionEvents.filter ({ $0.date >= Date() }) + viewModel.sessionEvents!.sessionEvents.filter ({ $0.date < Date() }), id:\.self) { sessionEvent in
                                SessionEventSubview(sessionEvent: sessionEvent)
                            }
                            .padding(.top, 5)
                            .padding(.bottom, 20)
                        }
                    }
                }
                
                Spacer()
            }
        }
        .frame(height: curHeight)
        .background (
            ZStack {
                if colorScheme == .light {
                    LinearGradient(
                        colors: [.blue.opacity(0.1), .white],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .cornerRadius(35)
                    .blur(radius: 2)
                    .ignoresSafeArea()
                } else {
                    LinearGradient(
                        colors: [.blue.opacity(0.15), .black],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .cornerRadius(35)
                    .blur(radius: 2)
                    .ignoresSafeArea()
                }
            }
                .background(
                    RoundedRectangle(cornerRadius: 35)
                        .fill(colorScheme == .light ? .white : .black)
                        .shadow(color: .gray.opacity(0.15), radius: 6, x: 0, y: -5))
        )
    }
    
    @State private var prevDragTrans = CGSize.zero
    
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .global)
            .onChanged { value in
                let dragAmount = value.translation.height - prevDragTrans.height
                if curHeight > maxHeight {
                    curHeight = maxHeight
                } else if curHeight < minHeight {
                    curHeight = minHeight
                } else {
                    if dragAmount > 0 { //вниз
                        if curHeight == maxHeight {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                curHeight = minHeight
                            }
                        }
                        
                    } else { //вверх
                        if curHeight == minHeight {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                curHeight = maxHeight
                            }
                        }
                    }
                }
                prevDragTrans = value.translation
            }
            .onEnded { value in
                prevDragTrans = .zero
            }
    }
}

#Preview {
    SessionEventsModalView(viewModel: ScheduleViewModelWithParsingSGU(), selectedGroup: GroupDTO(fullNumber: 141))
        .environmentObject(NetworkMonitor())
}