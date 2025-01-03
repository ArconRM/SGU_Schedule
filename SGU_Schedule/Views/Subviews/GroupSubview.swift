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
    /// Если группа с другого факультета
    var differentDepartment: Department?

    var body: some View {
        ZStack {
            if colorScheme == .light {
                getMainBackgroundLight()
            } else {
                getMainBackgroundDark()
            }

            VStack {
                HStack {
                    ZStack {
                        if appSettings.currentAppStyle == AppStyle.fill {
                            buildFilledRectangle()
                        } else {
                            buildBorderedRectangle()
                        }

                        Text(group.fullNumber)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .font(.system(size: 20))
                            .bold()
                    }
                    .frame(maxWidth: 90)

                    Text(differentDepartment != nil ? "\(group.fullName) (\(differentDepartment!.shortName))" : group.fullName)
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        .font(.system(size: 18, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .padding(.vertical, 20)

                    Spacer()

                    if isFavourite {
                        Image(systemName: "star.fill")
                            .font(.system(size: 25, weight: .semibold))
                            .padding(15)
                            .foregroundColor(appSettings.currentAppTheme.foregroundColor(colorScheme: colorScheme))
                            .shadow(color: appSettings.currentAppTheme.foregroundColor(colorScheme: colorScheme),
                                    radius: colorScheme == .light || appSettings.currentAppTheme == .gray ? 0 : 10)
                    }
                }
            }
        }
        .padding(.horizontal, 13)
        .padding(.top, 5)
        .frame(minHeight: 100)
    }

    private func getMainBackgroundLight() -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
//                  LinearGradient(
//                    stops: [
//                        .init(color: Color.white.opacity(0.6), location: 0.0),
//                        .init(color: Color.white, location: 0.3)
//                    ],
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                  )
                Color.white
            )
            .shadow(color: .gray.opacity(0.4), radius: 4, y: 0)
            .opacity(0.9)
    }

    private func getMainBackgroundDark() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        stops:
                            [
                                .init(color: appSettings.currentAppTheme != .gray ? getBackgroundColor().opacity(0.25) : Color.gray.opacity(0.1), location: 0.0),
                                .init(color: appSettings.currentAppTheme != .gray ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1), location: 0.9)
                            ],
                        startPoint: .leading,
                        endPoint: .trailing)
                )

            RoundedRectangle(cornerRadius: 20)
                .stroke(.gray.opacity(0.4))
                .blur(radius: 0.5)
        }
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
            .stroke(getBackgroundColor().opacity(isFavourite || isPinned ? 1 : 0.5), lineWidth: 4)
            .padding(2)
            .background {
//                if isFavourite || isPinned {
                    getBackgroundColor()
                    .opacity(isFavourite || isPinned ? 0.25 : 0.1)
                        .cornerRadius(18)
//                }
            }
    }

    private func getBackgroundColor() -> Color {
        appSettings.currentAppTheme.foregroundColor(colorScheme: colorScheme)
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
