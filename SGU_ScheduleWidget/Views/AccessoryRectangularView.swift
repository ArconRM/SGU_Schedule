//
//  AccessoryRectangularView.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 03.09.2024.
//

import SwiftUI
import WidgetKit

struct AccessoryRectangularView: View {
    var fetchResultVariant: ScheduleFetchResultVariants
    var currentEvent: (any ScheduleEventDTO)?
    var closeLesson: LessonDTO?
    
    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
                .cornerRadius(7)
            
            switch fetchResultVariant {
            case .UnknownErrorWhileFetching:
                Text("Произошла ошибка")
                    .bold()
            case .NoFavoriteGroup:
                Text("Не выбрана сохраненная группа")
                    .bold()
            case .Success:
                if closeLesson != nil {
                    VStack {
                        Text("Скоро (\(closeLesson!.timeStart.getHoursAndMinutesString())):")
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
                }
                else {
                    Text("Сегодня больше нет пар")
                        .bold()
                }
            }
        }
    }
}
