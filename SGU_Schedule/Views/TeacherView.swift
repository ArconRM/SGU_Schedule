//
//  TeacherView.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 28.05.2024.
//

import SwiftUI
import UIKit

struct TeacherView<ViewModel>: View, Equatable where ViewModel: TeacherViewModel {
    // чтобы не вью не переебашивалось при смене темы (и также источника инета)
    static func == (lhs: TeacherView<ViewModel>, rhs: TeacherView<ViewModel>) -> Bool {
        return lhs.colorScheme == rhs.colorScheme
    }

    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
    @EnvironmentObject var appSettings: AppSettings

    @ObservedObject var viewModel: ViewModel

    /// Если открыто с группы
    var teacherEndpoint: String?

    /// Если открыто с поиска
    var teacherLessonsEndpoint: String?

    var body: some View {
        if UIDevice.isPhone {
            NavigationView {
                buildUI()
            }
        } else if UIDevice.isPad {
            buildUI()
        }
    }

    private func buildUI() -> some View {
        ZStack {
            appSettings.currentAppTheme.backgroundColor(colorScheme: colorScheme)
                .ignoresSafeArea()
                .shadow(radius: 5)

            if teacherEndpoint != nil {
                CarouselView(pages: ["Инфа", "Расписание"], currentIndex: 0, viewsAlignment: .center) {
                    TeacherInfoView(viewModel: viewModel)
                        .padding(.bottom, 50)

                    TeacherScheduleView(viewModel: viewModel)
                }
            } else {
                TeacherScheduleView(viewModel: viewModel)
            }
        }
        .edgesIgnoringSafeArea(.bottom)

        .onAppear {
            if teacherEndpoint != nil {
                self.viewModel.fetchAll(teacherUrlEndpoint: teacherEndpoint!)
            } else {
                if teacherLessonsEndpoint == nil {
                    viewModel.showBaseError(error: BaseError.noSavedDataError)
                } else {
                    self.viewModel.fetchTeacherLessons(teacherLessonsUrlEndpoint: teacherLessonsEndpoint!)
                    self.viewModel.fetchTeacherSessionEvents(teacherSessionEventsUrlEndpoint: teacherLessonsEndpoint!)
                }
            }
        }
        .onChange(of: self.viewModel.isLoadingTeacherLessons) { _ in
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }

        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                CloseButton {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if teacherEndpoint != nil {
                            viewsManager.showScheduleView()
                        } else {
                            viewsManager.showTeachersSearchView()
                        }
                    }
                }
                .padding(.top, 5)
            }
        }

        .alert(isPresented: $viewModel.isShowingError) {
            Alert(title: Text(viewModel.activeError?.errorDescription ?? "Error"),
                  message: Text(viewModel.activeError?.failureReason ?? "Unknown"))
        }
    }
}

struct TeacherView_Previews: PreviewProvider {
    static var previews: some View {
        TeacherView(viewModel: ViewModelWithParsingSGUFactory().buildTeacherViewModel())
        .environmentObject(NetworkMonitor())
        .environmentObject(ViewsManager(appSettings: AppSettings(), viewModelFactory: ViewModelWithParsingSGUFactory(), viewModelFactory_old: ViewModelWithParsingSGUFactory_old(), groupSchedulePersistenceManager: GroupScheduleCoreDataManager(), groupSessionEventsPersistenceManager: GroupSessionEventsCoreDataManager(), groupPersistenceManager: GroupCoreDataManager(), isOpenedFromWidget: false))
        .environmentObject(AppSettings())
    }
}

// teacher: Teacher(
//    fullName: "Осипцев Михаил Анатольевич",
//    profileImageUrl: URL(string: "https://www.old1.sgu.ru/sites/default/files/styles/500x375_4x3/public/employee/facepics/7a630f4a70a5310d9152a3d5e5350a35/foto-1.jpg?itok=IILG1z3i")!,
//    email: "Osipcevm@gmail.com",
//    officeAddress: "9 учебный корпус СГУ, ком. 316",
//    workPhoneNumber: "+7 (8452) 51 - 55 - 37",
//    personalPhoneNumber: "",
//    birthdate: Date.now,
//    teacherLessonsUrl: URL(string: "https://www.sgu.ru/schedule/teacher/475")!,
// teacherSessionEventsUrl: URL(string: "https://www.sgu.ru/schedule/teacher/475#session")!,
