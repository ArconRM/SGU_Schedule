//
//  SingleSessionEventView.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 08.01.2025.
//

import Foundation
import SwiftUI

struct SingleSessionEventView: View {
    @EnvironmentObject var appSettings: AppSettings

    var fetchResult: SessionEventsFetchResult

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
        case .success(let consultation, let exam):
            if exam != nil {
                VStack {
                    Text(exam!.title)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .padding(.bottom, 0.1)
                        .multilineTextAlignment(.center)

                    if consultation != nil && !consultation!.date.passed(duration: Date.getDurationHours(sessionEventType: .consultation)) {
                        VStack {
                            Text("\(consultation!.sessionEventType.rawValue):")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .padding(.bottom, 0.5)
                                .multilineTextAlignment(.center)
                                .underline(consultation!.date.isToday())

                            Text(getEventDateString(event: consultation!))
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)

                            Text("\(consultation!.date.getHoursAndMinutesString())")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .padding(.bottom, 1)
                                .multilineTextAlignment(.center)

                            Text(consultation!.cabinet)
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .italic()
                                .multilineTextAlignment(.center)

                        }

                    } else {
                        VStack {
                            Text("\(exam!.sessionEventType.rawValue):")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                .padding(.bottom, 0.5)
                                .multilineTextAlignment(.center)
                                .underline(exam!.date.isToday())

                            Text(getEventDateString(event: exam!))
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)

                            Text("\(exam!.date.getHoursAndMinutesString())")
                                .font(.system(size: 15, weight: .bold, design: .rounded))
                                .padding(.bottom, 1)
                                .multilineTextAlignment(.center)

                            Text(exam!.cabinet)
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .italic()
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .foregroundColor(appSettings.currentAppStyle == AppStyle.fill ? .white : .none)
            } else {
                Text("Впереди экзаменов не наблюдается. Победа.")
                    .bold()
                    .foregroundColor(appSettings.currentAppStyle == AppStyle.fill ? .white : .none)
            }
        }
    }

    private func getEventDateString(event: SessionEventDTO) -> String {
        return event.date.isToday() ? "Сегодня" :
        event.date.isInFuture(days: 1) ? "Завтра" :
        "\(event.date.weekday.rawValue) \(event.date.getDayAndMonthWordString())"
    }
}
