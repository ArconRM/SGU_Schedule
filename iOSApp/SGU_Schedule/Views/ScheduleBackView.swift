//
//  ScheduleBackView.swift
//  SGU_Schedule
//
//  Created by Артемий on 29.01.2024.
//

import SwiftUI
import SguParser

struct ScheduleBackView<ViewModel>: View  where ViewModel: ScheduleViewModel {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appearanceSettings: AppearanceSettingsStore

    @StateObject var viewModel: ViewModel

    var selectedGroup: AcademicGroupDTO

    var body: some View {
        VStack {
            Text(selectedGroup.shortName)
                .font(.system(size: 30, weight: .bold))
                .padding(.top, -35)

            Text("Сейчас:")
                .font(.system(size: 20, weight: .bold))
                .padding()

            if let lesson = viewModel.currentEvent as? LessonDTO {
                Text(lesson.timeStart.getHoursAndMinutesString() + " - " +
                     lesson.timeEnd.getHoursAndMinutesString() + " " +
                     lesson.title)
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 5)

                Text(lesson.lessonType.rawValue)
                    .padding(.top, 2)
                    .padding(.bottom, 10)
                    .font(.system(size: 17, weight: .bold))
                    .padding(.horizontal, 5)

                Text(lesson.cabinet)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal, 5)

            } else if let timeBreak = viewModel.currentEvent as? TimeBreakDTO {
                Text(timeBreak.timeStart.getHoursAndMinutesString() + " - " +
                     timeBreak.timeEnd.getHoursAndMinutesString())
                    .font(.system(size: 20, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 5)

                Text(timeBreak.title)
                    .font(.system(size: 20, weight: .bold))
                    .padding(.horizontal, 5)

            } else {
                Text("-")
                    .font(.system(size: 20, weight: .bold))
            }

            Divider()

            Text("Далее:")
                .font(.system(size: 19, weight: .semibold))
                .padding()

            HStack {
                VStack {
                    if let nextLesson1 = viewModel.nextLesson1 {
                        Text(nextLesson1.timeStart.getHoursAndMinutesString() + "-" +
                             nextLesson1.timeEnd.getHoursAndMinutesString() + " " +
                             nextLesson1.title)
                        .font(.system(size: 17, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 5)

                        Text(nextLesson1.cabinet)
                            .padding()
                            .font(.system(size: 15, weight: .semibold))
                            .multilineTextAlignment(.center)
                    } else {
                        Text("-")
                            .font(.system(size: 20, weight: .bold))
                    }
                }

                VStack {
                    if let nextLesson2 = viewModel.nextLesson2 {
                        Text(nextLesson2.timeStart.getHoursAndMinutesString() + "-" +
                             nextLesson2.timeEnd.getHoursAndMinutesString() + " " +
                             nextLesson2.title)
                        .font(.system(size: 17, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 5)

                        Text(nextLesson2.cabinet)
                            .padding()
                            .font(.system(size: 15, weight: .semibold))
                            .multilineTextAlignment(.center)
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    ScheduleBackView(viewModel: ViewModelWithMockDataFactory().buildScheduleViewModel(),
                     selectedGroup: AcademicGroupDTO.mock)
    .environmentObject(AppearanceSettingsStore())
}
