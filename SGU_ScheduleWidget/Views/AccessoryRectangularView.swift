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
                if currentEvent == nil {
                    Text("Сейчас нет пар")
                        .bold()
                }
                else {
                    VStack {
                        Text("\(currentEvent!.timeStart.getHoursAndMinutesString()) - \(currentEvent!.timeEnd.getHoursAndMinutesString())")
                            .font(.system(size: 15, design: .rounded))
                            .bold()
//                            .padding(.top, 0)
                        
                        Text(currentEvent!.title)
                            .font(.system(size: 15, design: .rounded))
//                            .padding(.top, 1)
//                            .padding(.bottom, 0.9)
                    }
                    .frame(minHeight: 60)
                }
            }
        }
    }
}
