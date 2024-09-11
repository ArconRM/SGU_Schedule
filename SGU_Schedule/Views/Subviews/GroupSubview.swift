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
    
    var group: AcademicGroupDTO
    var isFavourite: Bool
    var isPinned: Bool
    
    var body: some View {
        VStack {
            HStack {
                    ZStack {
                        if appSettings.currentAppStyle == AppStyle.Fill.rawValue {
                            buildFilledRectangle()
                        } else {
                            buildBorderedRectangle()
                        }
                        
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
                
                Spacer()
                
                if isFavourite {
                    Image(systemName: "star.fill")
                        .font(.system(size: 25, weight: .semibold))
                        .padding(15)
                        .foregroundColor(AppTheme(rawValue: appSettings.currentAppTheme)!.foregroundColor(colorScheme: colorScheme))
                }
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
            .cornerRadius(20)
            .foregroundColor(getBackgroundColor().opacity(isFavourite || isPinned ? 0.6 : 0.3))
            .shadow(color: getBackgroundColor().opacity(0.7), radius: 7, x: 2, y: 2)
            .blur(radius: 1)
    }
    
    private func buildBorderedRectangle() -> some View {
        RoundedRectangle(cornerRadius: 18)
            .stroke(getBackgroundColor().opacity(isFavourite || isPinned ? 1 : 0.3), lineWidth: 4)
            .padding(2)
        // В сером цвете при темной теме не видно иначе
            .background {
                if (isFavourite || isPinned) && appSettings.currentAppTheme == AppTheme.Gray.rawValue && colorScheme == .dark {
                    getBackgroundColor()
                        .opacity(0.3)
                        .cornerRadius(18)
                }
            }
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
                GroupSubview(group: AcademicGroupDTO(fullNumber: "141", departmentCode: "knt"), isFavourite: true, isPinned: false)
                    .environmentObject(AppSettings())
                
                GroupSubview(group: AcademicGroupDTO(fullNumber: "121", departmentCode: "knt"), isFavourite: false, isPinned: true)
                    .environmentObject(AppSettings())
                
                GroupSubview(group: AcademicGroupDTO(fullNumber: "131", departmentCode: "knt"), isFavourite: false, isPinned: false)
                    .environmentObject(AppSettings())
            }
        }
    }
}
