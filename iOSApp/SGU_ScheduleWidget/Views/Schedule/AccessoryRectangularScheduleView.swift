//
//  AccessoryRectangularScheduleView.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 03.09.2024.
//

import SwiftUI
import WidgetKit
import SguParser

struct AccessoryRectangularScheduleView: View {

    var fetchResult: ScheduleEventsFetchResult
    var closeLesson: LessonDTO?

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
                .cornerRadius(7)

            switch fetchResult {
            case .unknownErrorWhileFetching:
                Text("Произошла ошибка")
                    .bold()
            case .noFavoriteGroup:
                Text("Не выбрана сохраненная группа")
                    .bold()
            case .success(let currentEvent, _, _):
                if closeLesson != nil {
                    VStack {
                        Text("Скоро (\(closeLesson!.timeStart.getHoursAndMinutesString()))")
                            .font(.system(size: 15, design: .rounded))
                            .bold()

                        Text(closeLesson!.title)
                            .font(.system(size: 15, design: .rounded))
                    }
                    .frame(minHeight: 60)
                } else if currentEvent != nil {
                    VStack {
                        Text("\(currentEvent!.timeStart.getHoursAndMinutesString()) - \(currentEvent!.timeEnd.getHoursAndMinutesString())")
                            .font(.system(size: 15, design: .rounded))
                            .bold()

                        Text(currentEvent!.title)
                            .font(.system(size: 15, design: .rounded))
                    }
                    .frame(minHeight: 60)
                } else {
                    Text("Пока нет пар")
                        .bold()
                }
            }
        }
    }
}
