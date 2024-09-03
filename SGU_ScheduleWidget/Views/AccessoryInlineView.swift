//
//  AccessoryInlineView.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 03.09.2024.
//

import SwiftUI
import WidgetKit

struct AccessoryInlineView: View {
    var fetchResultVariant: ScheduleFetchResultVariants
    var currentEvent: (any ScheduleEventDTO)?
    
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
                if currentEvent == nil {
                    Text("Сейчас нет пар")
                        .bold()
                }
                else {
                    Text("\(currentEvent!.timeStart.getHoursAndMinutesString())-\(currentEvent!.timeEnd.getHoursAndMinutesString()) \(currentEvent!.title)")
                }
            }
        }
    }
}
