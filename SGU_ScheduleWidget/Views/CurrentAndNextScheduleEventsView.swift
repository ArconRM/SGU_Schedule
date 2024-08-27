//
//  CurrentAndNextScheduleEventsView.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 06.08.2024.
//

import SwiftUI

struct CurrentAndNextScheduleEventsView: View {
    var fetchResultVariant: ScheduleFetchResultVariants
    var currentEvent: (any ScheduleEventDTO)?
    var nextEvent: (any ScheduleEventDTO)?
    
    var body: some View {
        switch fetchResultVariant {
        case .UnknownErrorWhileFetching:
            Text("Произошла ошибка")
        case .NoFavoriteGroup:
            Text("Не выбрана сохраненная группа")
        case .Success:
            if currentEvent == nil {
                Text("Сейчас нет пар")
            } else {
                HStack {
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
                    .padding(.trailing, 10)
                    
                    Divider()
                    
                    if nextEvent == nil {
                        Text("Дальше пар нет, кайфуем")
                    } else {
                        VStack {
                            Text("\(nextEvent!.timeStart.getHoursAndMinutesString()) - \(nextEvent!.timeEnd.getHoursAndMinutesString())")
                                .font(.system(size: 16))
                                .bold()
                                .padding(.bottom, 0.5)
                            
                            Divider()
                            
                            Text(nextEvent!.title)
                                .font(.system(size: 15))
                                .padding(.vertical, 2)
                                .multilineTextAlignment(.center)
                            
                            if let nextEvent = nextEvent as? LessonDTO {
                                Text(nextEvent.cabinet)
                                    .font(.system(size: 13))
                                    .italic()
                            }
                            
                            Spacer()
                        }
                        .padding(.leading, 10)
                    }
                }
            }
        }
    }
}
