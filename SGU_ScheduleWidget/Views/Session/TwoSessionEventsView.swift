//
//  TwoSessionEventsView.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 08.01.2025.
//

import Foundation
import SwiftUI

struct TwoSessionEventsView: View {
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
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .multilineTextAlignment(.center)

                    if consultation != nil {
                        HStack {
                            VStack {
                                Text("\(consultation!.sessionEventType.rawValue):")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .padding(.bottom, 0.5)
                                    .multilineTextAlignment(.center)
                                    .underline(consultation!.date.isToday())

                                Text(getEventDateString(event: consultation!))
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .multilineTextAlignment(.center)

                                Spacer()

                                Text(consultation!.cabinet)
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .italic()
                                    .multilineTextAlignment(.center)

                            }
                            .strikethrough(consultation!.date.passed(duration: Date.getDurationHours(sessionEventType: .consultation)))
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(10)

                            VStack {
                                Text("\(exam!.sessionEventType.rawValue):")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .padding(.bottom, 0.5)
                                    .multilineTextAlignment(.center)
                                    .underline(exam!.date.isToday())

                                Text(getEventDateString(event: exam!))
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .multilineTextAlignment(.center)

                                Spacer()

                                Text(exam!.cabinet)
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .italic()
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(.gray.opacity(0.2))
                            .cornerRadius(10)
                        }

                    } else {
                        Divider()

                        Text("\(exam!.sessionEventType.rawValue):")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 1)
                            .underline(exam!.date.isToday())

                        Text(getEventDateString(event: exam!))
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .padding(.bottom, 5)
                            .multilineTextAlignment(.center)

                        Spacer()

                        Text(exam!.cabinet)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .italic()
                            .multilineTextAlignment(.center)
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
        return event.date.isToday() ? "Сегодня, \(event.date.getHoursAndMinutesString())" :
        event.date.isInFuture(days: 1) ? "Завтра, \(event.date.getHoursAndMinutesString())" :
        "\(event.date.weekday.rawValue) \(event.date.getDayAndMonthWordString()), \(event.date.getHoursAndMinutesString())"
    }
}
