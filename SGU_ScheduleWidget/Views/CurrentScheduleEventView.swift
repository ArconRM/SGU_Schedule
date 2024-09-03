//
//  CurrentScheduleEventView.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 03.08.2024.
//

import SwiftUI

struct CurrentScheduleEventView: View {
    @EnvironmentObject var appSettings: AppSettings
    
    var fetchResultVariant: ScheduleFetchResultVariants
    var currentEvent: (any ScheduleEventDTO)?
    
    var body: some View {
        switch fetchResultVariant {
        case .UnknownErrorWhileFetching:
            Text("Произошла ошибка")
                .bold()
                .foregroundColor(appSettings.currentAppStyle == AppStyle.fill.rawValue ? .white : .none)
        case .NoFavoriteGroup:
            Text("Не выбрана сохраненная группа")
                .bold()
                .foregroundColor(appSettings.currentAppStyle == AppStyle.fill.rawValue ? .white : .none)
        case .Success:
            if currentEvent == nil {
                Text("Сейчас нет пар")
                    .bold()
                    .foregroundColor(appSettings.currentAppStyle == AppStyle.fill.rawValue ? .white : .none)
            }
            else {
                VStack {
                    Text("\(currentEvent!.timeStart.getHoursAndMinutesString()) - \(currentEvent!.timeEnd.getHoursAndMinutesString())")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .bold()
                        .padding(.bottom, 0.5)
                    
                    Text(currentEvent!.title)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .padding(.vertical, 2)
                        .multilineTextAlignment(.center)
                    
                    if let currentLesson = currentEvent as? LessonDTO {
                        Text(currentLesson.cabinet)
                            .font(.system(size: 13, weight: .light, design: .rounded))
                            .italic()
                    }
                    
                    Spacer()
                }
                .foregroundColor(appSettings.currentAppStyle == AppStyle.fill.rawValue ? .white : .none)
            }
        }
    }
}
