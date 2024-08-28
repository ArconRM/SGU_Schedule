//
//  GroupSubview.swift
//  SGU_Schedule
//
//  Created by Артемий on 20.09.2023.
//

import SwiftUI

struct GroupSubview: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSettings: AppSettings
    
    var group: GroupDTO
    var isFavorite: Bool
    
    var body: some View {
        VStack {
            HStack {
                if appSettings.currentAppStyle == AppStyle.fill.rawValue {
                    ZStack {
                        buildFilledRectangle()
                        
                        Text(String(group.fullNumber))
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .font(.system(size: 20))
                            .bold()
                    }
                    .frame(maxWidth: 90)
                    
                    Text(group.fullName)
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        .font(.system(size: 18, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 20)
                    
                } else {
                    ZStack {
                        buildBorderedRectangle()
                        
                        Text(String(group.fullNumber))
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .font(.system(size: 20))
                            .bold()
                    }
                    .frame(maxWidth: 90)
                    
                    Text(group.fullName)
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        .font(.system(size: 18, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 20)
                }
                
                Spacer()
            }
        }
        .cornerRadius(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .light ? .white : .white.opacity(0.2))
                .shadow(color: .gray.opacity(0.25), radius: 5, x: 0, y: 5)
                .blur(radius: 0.5)
        )
        .padding(.horizontal, 13)
        .padding(.top, 5)
        .frame(minHeight:100)
    }
    
    private func buildFilledRectangle() -> some View {
        Rectangle()
            .cornerRadius(10)
            .foregroundColor(getBackgroundColor().opacity(isFavorite ? 0.6 : 0.3))
            .shadow(color: .cyan.opacity(0.7), radius: 7, x: 2, y: 2)
            .blur(radius: 1)
    }
    
    private func buildBorderedRectangle() -> some View {
        RoundedRectangle(cornerRadius: 18)
            .stroke(getBackgroundColor().opacity(isFavorite ? 1 : 0.3), lineWidth: 4)
            .padding(2)
    }
    
    private func getBackgroundColor() -> Color {
        AppTheme(rawValue: appSettings.currentAppTheme)?.foregroundColor(colorScheme: colorScheme) ?? .red
    }
}

struct GroupSubview_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.blue.opacity(0.1))
                .ignoresSafeArea()
            ScrollView {
                GroupSubview(group: GroupDTO(fullNumber: 141), isFavorite: true)
                    .environmentObject(AppSettings())
                
                GroupSubview(group: GroupDTO(fullNumber: 131), isFavorite: false)
                    .environmentObject(AppSettings())
            }
        }
    }
}
