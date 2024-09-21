//
//  TutorialView.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 04.09.2024.
//

import SwiftUI

fileprivate enum TutorialViews {
    case Widgets
    case FavoriteGroup
}

struct TutorialView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isShowing: Bool
    @State fileprivate var currentView: TutorialViews = .Widgets
    @State private var widgetsViewOpacity = 0.2
    
    var body: some View {
        ZStack {
            Color.gray
                .opacity(0.4)
            
            VStack {
                HStack {
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.4)) {
                            isShowing.toggle()
                        }
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                            .padding(.leading, 10)
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                    })
                    
                    Spacer()
                }
                switch currentView {
                case .Widgets:
                    getWidgetsTutorialView()
                case .FavoriteGroup:
                    getFavouriteTutorialView()
                }
            }
            .background(colorScheme == .light ? .white : .black)
            .cornerRadius(20)
//            .scaleEffect(CGSize(width: 0.86, height: 0.86))
            .frame(width: UIScreen.screenWidth - 20, height: UIScreen.screenHeight * 0.86)
        }
        .ignoresSafeArea()
    }
    
    private func getWidgetsTutorialView() -> some View {
        return VStack {
            Text("Виджеты на экране \"Домой\"")
                .font(.system(size: 23, design: .rounded))
                .bold()
                .padding(.top, 5)
                .padding(.horizontal, 5)
                .frame(maxWidth: .infinity)
            
            Image("WidgetsOnHomeScreen")
                .resizable()
                .aspectRatio(contentMode: ContentMode.fit)
                .cornerRadius(20)
                .padding(.horizontal)
            
            Text("Виджеты на экране блокировки")
                .font(.system(size: 23, design: .rounded))
                .bold()
                .padding(.top, 30)
                .padding(.horizontal, 5)
                .frame(maxWidth: .infinity)
            
            Image("WidgetsOnLockScreen")
                .resizable()
                .aspectRatio(contentMode: ContentMode.fit)
                .cornerRadius(20)
                .padding(.horizontal)
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button("Далее") {
                    withAnimation(.bouncy(duration: 0.7)) {
                        currentView = .FavoriteGroup
                    }
                }
                .padding(30)
                .font(.system(size: 18, weight: .bold, design: .rounded))
            }
        }
        .opacity(widgetsViewOpacity)
        .animation(.easeIn(duration: 0.4), value: widgetsViewOpacity)
        .onAppear {
            widgetsViewOpacity = 1
        }
        .gesture(
            DragGesture().onEnded({ value in
                if value.translation.width < -70 {
                    withAnimation(.easeIn(duration: 0.4)) {
                        currentView = .FavoriteGroup
                    }
                }
            })
        )
    }
    
    private func getFavouriteTutorialView() -> some View {
        VStack {
            VStack {
                Text("Для работы виджета нужно выбрать избранную группу")
                    .font(.system(size: 23, design: .rounded))
                    .bold()
                    .padding(.top, 10)
                    .padding(.horizontal, 5)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                
                Image("SetFavouriteGroup")
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .cornerRadius(20)
                    .padding(.horizontal)
                
                Text("Доступ к ней будет и в оффлайне")
                    .font(.system(size: 23, design: .rounded))
                    .bold()
                    .padding(.top, 50)
                    .padding(.horizontal, 5)
                    .frame(maxWidth: .infinity)
                
                Image("OfflineFavouriteGroup")
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                HStack {
                    Button("Назад") {
                        withAnimation(.bouncy(duration: 0.7)) {
                            currentView = .Widgets
                        }
                    }
                    .padding(30)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    
                    Spacer()
                    
                    Button("Закрыть") {
                        withAnimation(.easeOut(duration: 0.4)) {
                            isShowing.toggle()
                        }
                    }
                    .padding(30)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                }
            }
        }
        .gesture(
            DragGesture().onEnded({ value in
                if value.translation.width > 70 {
                    withAnimation(.bouncy(duration: 0.7)) {
                        currentView = .Widgets
                    }
                }
            })
        )
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [.red, .blue], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
        
        TutorialView(isShowing: .constant(true))
    }
}
