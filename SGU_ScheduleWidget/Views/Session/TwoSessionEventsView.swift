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
                        .padding(.vertical, 0.5)
                        .multilineTextAlignment(.center)

                    Text(exam!.teacherFullName)
                        .font(.system(size: 14, weight: .medium, design: .rounded))

                    if consultation != nil {
                        HStack {
                            VStack {
                                Text("\(consultation!.sessionEventType.rawValue):")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .padding(.bottom, 0.5)
                                    .multilineTextAlignment(.center)
                                    .underline(consultation!.date.isAroundNow())

                                Text("\(consultation!.date.weekday.rawValue) \(consultation!.date.getDayAndMonthWordString()), \(consultation!.date.getHoursAndMinutesString())")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .padding(.bottom, 0.5)
                                    .multilineTextAlignment(.center)

                                Text(consultation!.cabinet)
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .italic()
                                    .padding(.bottom, 0.5)
                                    .multilineTextAlignment(.center)

                            }
                            .strikethrough(consultation!.date.passed())

                            Divider()
                                .padding(.horizontal, 10)

                            VStack {
                                Text("\(exam!.sessionEventType.rawValue):")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .padding(.bottom, 0.5)
                                    .multilineTextAlignment(.center)
                                    .underline(exam!.date.isAroundNow())

                                Text("\(exam!.date.weekday.rawValue) \(exam!.date.getDayAndMonthWordString()), \(exam!.date.getHoursAndMinutesString())")
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .padding(.bottom, 0.5)
                                    .multilineTextAlignment(.center)

                                Text(exam!.cabinet)
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .italic()
                                    .padding(.bottom, 0.5)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.vertical, 1)

                    } else {
                        Divider()

                        Text("\(exam!.sessionEventType.rawValue):")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 1)
                            .underline(exam!.date.isAroundNow())

                        Text("\(exam!.date.weekday.rawValue) \(exam!.date.getDayAndMonthWordString()), \(exam!.date.getHoursAndMinutesString())")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .padding(.bottom, 5)
                            .multilineTextAlignment(.center)

                        Text(exam!.cabinet)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .italic()
                            .padding(.bottom, 0.5)
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
}
