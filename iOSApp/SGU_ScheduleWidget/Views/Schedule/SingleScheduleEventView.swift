//
//  SingleScheduleEventView.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 03.08.2024.
//

import SwiftUI
import SguParser

struct SingleScheduleEventView: View {
    @EnvironmentObject var appearanceSettings: AppearanceSettingsStore

    var fetchResult: ScheduleEventsFetchResult
    var closeLesson: LessonDTO?

    var body: some View {
        switch fetchResult {
        case .unknownErrorWhileFetching:
            Text("Произошла ошибка")
                .bold()
                .foregroundColor(appearanceSettings.currentAppStyle == AppStyle.fill ? .white : .none)
        case .noFavoriteGroup:
            Text("Не выбрана сохраненная группа")
                .bold()
                .foregroundColor(appearanceSettings.currentAppStyle == AppStyle.fill ? .white : .none)
        case .success(let currentEvent, _, _):
            if closeLesson != nil {
                VStack {
                    Text("Скоро")
                        .font(.system(size: 12, weight: .bold, design: .rounded))

                    Text("(\(closeLesson!.timeStart.getHoursAndMinutesString()))")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .padding(.bottom, 0.5)

                    Text(closeLesson!.title)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .padding(.vertical, 2)
                        .multilineTextAlignment(.center)

                    Text(closeLesson!.cabinet)
                        .font(.system(size: 13, weight: .light, design: .rounded))
                        .italic()

                    Spacer()
                }
                .foregroundColor(appearanceSettings.currentAppStyle == AppStyle.fill ? .white : .none)

            } else if currentEvent != nil {
                VStack {
                    Text("\(currentEvent!.timeStart.getHoursAndMinutesString()) - \(currentEvent!.timeEnd.getHoursAndMinutesString())")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .bold()
                        .padding(.bottom, 0.5)

                    Text(currentEvent!.title)
                        .font(.system(size: 15, weight: .heavy, design: .rounded))
                        .padding(.vertical, 2)
                        .multilineTextAlignment(.center)
                        .foregroundColor(getTextColor(event: currentEvent))

                    Spacer()

                    if let currentLesson = currentEvent as? LessonDTO {
                        Text(currentLesson.cabinet)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .italic()
                    }
                }
                .foregroundColor(appearanceSettings.currentAppStyle == AppStyle.fill ? .white : .none)

            } else {
                Text("Пока нет пар")
                    .bold()
                    .foregroundColor(appearanceSettings.currentAppStyle == AppStyle.fill ? .white : .none)
            }
        }
    }

    private func getTextColor(event: (any ScheduleEvent)?) -> Color {
        if let lesson = event as? LessonDTO {
            return lesson.lessonType == .lecture ? .green : .blue
        }
        return .gray
    }
}
