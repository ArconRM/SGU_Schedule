//
//  ErrorView.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 09.06.2024.
//

import SwiftUI

struct ErrorView: View {
    //чтобы не вью не переебашивалось при смене темы (и также источника инета)
    static func == (lhs: ErrorView, rhs: ErrorView) -> Bool {
        return lhs.colorScheme == rhs.colorScheme
    }
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewsManager: ViewsManager
    
    @State var error: String
    
    var body: some View {
        Text(error)
            .font(.system(size: 20))
        
            .toolbar {
                makeCloseToolbarItem()
            }
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
            }
        }
    }
}

#Preview {
    ErrorView(error: "Что-то пошло не так")
}
