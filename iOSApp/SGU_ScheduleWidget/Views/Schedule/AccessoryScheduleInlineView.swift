//
//  AccessoryScheduleInlineView.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 03.09.2024.
//

import SwiftUI
import WidgetKit

struct AccessoryScheduleInlineView: View {

    var fetchResult: ScheduleEventsFetchResult
    var closeLesson: LessonDTO?

    var body: some View {
        ZStack {
            switch fetchResult {
            case .unknownErrorWhileFetching:
                Text("Произошла ошибка")
                    .bold()
            case .noFavoriteGroup:
                Text("Не выбрана сохраненная группа")
                    .bold()
            case .success(let currentEvent, _, _):
                if closeLesson != nil {
                    Text("Скоро (\(closeLesson!.timeStart.getHoursAndMinutesString())) \(closeLesson!.title)")

                } else if currentEvent != nil {
                    Text("до \(currentEvent!.timeEnd.getHoursAndMinutesString()): \(currentEvent!.title)")

                } else {
                    Text("Пока нет пар")
                }
            }
        }
    }
}
