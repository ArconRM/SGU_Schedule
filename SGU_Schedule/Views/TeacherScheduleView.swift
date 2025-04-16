//
//  TeacherScheduleView.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 31.10.2024.
//

import SwiftUI

struct TeacherScheduleView<ViewModel>: View, Equatable where ViewModel: TeacherViewModel {
    // чтобы не вью не переебашивалось при смене темы (и также источника инета)
    static func == (lhs: TeacherScheduleView<ViewModel>, rhs: TeacherScheduleView<ViewModel>) -> Bool {
        return lhs.colorScheme == rhs.colorScheme
    }

    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
    @EnvironmentObject var appearanceSettings: AppearanceSettingsStore

    @ObservedObject var viewModel: ViewModel

    @State private var selectedTeacherScheduleVariant: TeacherSchedulePickerVariants = .lessons
    @State private var selectedDay: Weekdays = Date.currentWeekDayWithoutSundayAndWithEveningBeingNextDay
    @State private var lessonsBySelectedDay = [LessonDTO]()

    private enum TeacherSchedulePickerVariants: String, CaseIterable {
        case lessons = "Занятия"
        case session = "Сессия"
    }

    var body: some View {
        ScrollView {
            Picker("", selection: $selectedTeacherScheduleVariant) {
                ForEach(TeacherSchedulePickerVariants.allCases, id: \.self) { variant in
                    Text(variant.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.top)

            if selectedTeacherScheduleVariant == .lessons {
                if viewModel.isLoadingTeacherLessons {
                    ProgressView()
                } else {
                    Picker("", selection: $selectedDay) {
                        ForEach(Weekdays.allCases.dropLast(), id: \.self) { day in
                            Text(day.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    .padding(.bottom)
                    .onChange(of: selectedDay) { _ in
                        lessonsBySelectedDay = viewModel.teacherLessons.filter { $0.weekDay == selectedDay }
                    }

                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(1...8, id: \.self) { lessonNumber in
                            let lessonsByNumber = lessonsBySelectedDay.filter { $0.lessonNumber == lessonNumber }
                            if !lessonsByNumber.isEmpty {
                                // id нужен чтобы переебашивало все вью, иначе оно сохраняет его флаг
                                ScheduleSubview(lessons: lessonsByNumber, subgroupsByLessons: [:])
                                    .environmentObject(networkMonitor)
                                    .environmentObject(viewsManager)
                                    .id(UUID())
                            }
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 60)
                        .padding(.horizontal, 13)
                    }
                    .onAppear {
                        lessonsBySelectedDay = viewModel.teacherLessons.filter { $0.weekDay == selectedDay }
                    }
                }
            } else if selectedTeacherScheduleVariant == .session {
                if viewModel.isLoadingTeacherSessionEvents {
                    ProgressView()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(viewModel.teacherSessionEvents.filter({ $0.date >= Date() }) + viewModel.teacherSessionEvents.filter({ $0.date < Date() }), id: \.self) { sessionEvent in
                            SessionEventSubview(sessionEvent: sessionEvent)
                        }
                        .padding(.top, 5)
                        .padding(.bottom, 60)
                        .padding(.horizontal, 13)
                    }
                }
            }
        }
        .padding(.top, 10)
    }
}

#Preview {
    TeacherScheduleView(viewModel: ViewModelWithMockDataFactory().buildTeacherViewModel())
}
