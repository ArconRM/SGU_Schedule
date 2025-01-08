//
//  TwoScheduleEventsView.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 06.08.2024.
//

import SwiftUI

struct TwoScheduleEventsView: View {
    @EnvironmentObject var appSettings: AppSettings

    var fetchResult: ScheduleEventsFetchResult
    var closeLesson: LessonDTO?

    var body: some View {
        switch fetchResult {
        case .unknownErrorWhileFetching:
            Text("Произошла ошибка")
                .bold()
                .foregroundColor(appSettings.currentAppStyle == AppStyle.fill ? .white : .none)
        case .noFavoriteGroup:
            Text("Не выбрана сохраненная группа")
                .bold()
                .foregroundColor(appSettings.currentAppStyle == AppStyle.fill ? .white : .none)
        case .success(let currentEvent, _, let nextLesson):
            if closeLesson != nil {
                VStack {
                    Spacer()
                    Text("Скоро (\(closeLesson!.timeStart.getHoursAndMinutesString()))")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .padding(.bottom, 0.5)

                    Text(closeLesson!.title)
                        .font(.system(size: 17, weight: .medium, design: .rounded))
                        .padding(.vertical, 2)
                        .multilineTextAlignment(.center)

                    Text(closeLesson!.cabinet)
                        .font(.system(size: 16, weight: .light, design: .rounded))
                        .italic()
                        .padding(.top, 1)

                    Spacer()
                }
                .foregroundColor(appSettings.currentAppStyle == AppStyle.fill ? .white : .none)

            } else if currentEvent != nil {
                HStack {
                    VStack {
                        Text("\(currentEvent!.timeStart.getHoursAndMinutesString()) - \(currentEvent!.timeEnd.getHoursAndMinutesString())")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .padding(.bottom, 0.5)

                        Text(currentEvent!.title)
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                            .padding(.vertical, 2)
                            .multilineTextAlignment(.center)

                        if let currentLesson = currentEvent as? LessonDTO {
                            Text(currentLesson.cabinet)
                                .font(.system(size: 13, weight: .light, design: .rounded))
                                .italic()
                                .padding(.top, 1)
                        }

                        Spacer()
                    }
                    .padding(.trailing, 10)

                    Divider()

                    if nextLesson == nil {
                        Spacer()
                        Text("Дальше пар нет, кайфуем")
                        Spacer()
                    } else {
                        VStack {
                            Text("\(nextLesson!.timeStart.getHoursAndMinutesString()) - \(nextLesson!.timeEnd.getHoursAndMinutesString())")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .padding(.bottom, 0.5)

                            Text(nextLesson!.title)
                                .font(.system(size: 15, weight: .medium, design: .rounded))
                                .padding(.vertical, 2)
                                .multilineTextAlignment(.center)

                            Text(nextLesson!.cabinet)
                                .font(.system(size: 13, weight: .light, design: .rounded))
                                .italic()
                                .padding(.top, 1)

                            Spacer()
                        }
                        .padding(.leading, 10)
                    }
                }
                .foregroundColor(appSettings.currentAppStyle == AppStyle.fill ? .white : .none)

            } else {
                Text("Пока нет пар")
                    .bold()
                    .foregroundColor(appSettings.currentAppStyle == AppStyle.fill ? .white : .none)
            }
        }
    }
}
