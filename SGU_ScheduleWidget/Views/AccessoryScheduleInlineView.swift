//
//  AccessoryScheduleInlineView.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 03.09.2024.
//

import SwiftUI
import WidgetKit

struct AccessoryScheduleInlineView: View {
    var fetchResultVariant: ScheduleFetchResultVariants
    var currentEvent: (any ScheduleEvent)?
    var closeLesson: LessonDTO?
    
    var body: some View {
        ZStack {
            switch fetchResultVariant {
            case .UnknownErrorWhileFetching:
                Text("Произошла ошибка")
                    .bold()
            case .NoFavoriteGroup:
                Text("Не выбрана сохраненная группа")
                    .bold()
            case .Success:
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
