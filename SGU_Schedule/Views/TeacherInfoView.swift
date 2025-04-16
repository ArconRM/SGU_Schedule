//
//  TeacherInfoView.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 31.05.2024.
//

import SwiftUI

struct TeacherInfoView<ViewModel>: View, Equatable where ViewModel: TeacherViewModel {
    // чтобы не вью не переебашивалось при смене темы (и также источника инета)
    static func == (lhs: TeacherInfoView, rhs: TeacherInfoView) -> Bool {
        return lhs.colorScheme == rhs.colorScheme
    }

    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appearanceSettings: AppearanceSettingsStore

    @ObservedObject var viewModel: ViewModel

//    @State var isCollapsed: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            //            Image("foto-1")
            //                .resizable()
            //                .aspectRatio(contentMode: ContentMode.fit)
            //                .cornerRadius(20)
            //                .padding(2)
            VStack {
                AsyncImage(url: viewModel.teacher?.profileImageUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: ContentMode.fit)
                        .cornerRadius(20)
                        .shadow(radius: 3)
                } placeholder: {
                    ProgressView()
                        .padding(10)
                }

                Divider()

                Text(viewModel.isLoadingTeacherInfo ? "Загрузка..." : viewModel.teacher?.fullName ?? "Ошибка")
                    .font(.system(size: 18))
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)

                if let departmentFullName = viewModel.teacher?.departmentFullName {
                    Text(departmentFullName)
                        .font(.system(size: 18, weight: .thin))
                        .italic()
                        .padding(.top, 3)
                }
            }

            //                if !self.isCollapsed {

            Text("Дата рождения: " + (viewModel.teacher?.birthdate?.getDayMonthAndYearString() ?? ""))
                .padding(.top, 10)

            Text("Email: " + (viewModel.teacher?.email ?? ""))
                .padding(.top, 10)

            Text("Рабочий телефон: " + (viewModel.teacher?.workPhoneNumber ?? ""))
                .padding(.top, 10)

            Text("Личный телефон: " + (viewModel.teacher?.personalPhoneNumber ?? ""))
                .padding(.top, 10)
            //                }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 20)
        .foregroundColor(colorScheme == .light ? .black : .white)
        .background(
            getBackground()
                .overlay {
                    if appearanceSettings.currentAppTheme == .pinkHelloKitty {
                        Image("patternImageRofl3")
                            .resizable()
                            .ignoresSafeArea()
                            .scaledToFit()
                            .clipped()
                            .opacity(0.1)
                    }
                }
        )
        .frame(maxHeight: UIScreen.screenHeight * 0.8)
        .padding(.horizontal, 20)
    }

    private func getBackground() -> AnyView {
        switch appearanceSettings.currentAppStyle {
        case .fill:
            AnyView(
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .light ? .white : .white.opacity(0.1))
                    .shadow(color: .gray.opacity(0.25), radius: 5, x: 0, y: 5)
                    .blur(radius: 0.5)
                    .opacity(0.8)
            )
        case .bordered:
            AnyView(
                ZStack {
                    (colorScheme == .light ? Color.white : Color.white.opacity(0.1))
                        .cornerRadius(20)

                    RoundedRectangle(cornerRadius: 20)
                        .stroke(appearanceSettings.currentAppTheme.foregroundColor(colorScheme: colorScheme).opacity(0.6), lineWidth: 4)
                }
            )
        }
    }
}

#Preview {
    ZStack {
        AppTheme.blue.backgroundColor(colorScheme: .dark)
            .ignoresSafeArea()
            .shadow(radius: 5)

        TeacherInfoView(
            viewModel: ViewModelWithMockDataFactory().buildTeacherViewModel()
        )
        .environmentObject(AppearanceSettingsStore())
    }
}
