//
//  CurrentScheduleEventView.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 03.08.2024.
//

import SwiftUI

struct CurrentScheduleEventView: View {
    var fetchResultVariant: ScheduleFetchResultVariants
    var currentEvent: (any ScheduleEventDTO)?
    
    var body: some View {
        switch fetchResultVariant {
        case .UnknownErrorWhileFetching:
            Text("Произошла ошибка")
        case .NoFavoriteGroup:
            Text("Не выбрана сохраненная группа")
        case .Success:
            if currentEvent == nil {
                Text("Сейчас нет пар")
            }
            else {
                VStack {
                    Text("\(currentEvent!.timeStart.getHoursAndMinutesString()) - \(currentEvent!.timeEnd.getHoursAndMinutesString())")
                        .font(.system(size: 16))
                        .bold()
                        .padding(.bottom, 0.5)
                    
                    Divider()
                    
                    Text(currentEvent!.title)
                        .font(.system(size: 15))
                        .padding(.vertical, 2)
                        .multilineTextAlignment(.center)
                    
                    if let currentLesson = currentEvent as? LessonDTO {
                        Text(currentLesson.cabinet)
                            .font(.system(size: 13))
                            .italic()
                    }
                    
                    Spacer()
                }
            }
        }
    }
}
