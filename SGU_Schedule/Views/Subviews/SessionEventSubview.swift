//
//  SessionEventSubview.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.01.2024.
//

import SwiftUI

struct SessionEventSubview: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSettings: AppSettings

    let sessionEvent: SessionEventDTO

    var body: some View {
        VStack {
            VStack {
                Text(sessionEvent.title)
                    .font(.system(size: 20))
                    .bold()
                    .multilineTextAlignment(.center)

                Text(sessionEvent.sessionEventType.rawValue)
                    .font(.system(size: 17))
                    .italic()
                    .multilineTextAlignment(.center)

                HStack {
                    Text(sessionEvent.date.getDayMonthAndYearString())
                        .font(.system(size: 20))
                        .bold()

                    Text(sessionEvent.date.getHoursAndMinutesString())
                        .font(.system(size: 20))
                }
                .padding(.vertical, 10)

                HStack {
                    Text(sessionEvent.cabinet)
                        .font(.system(size: 17))

                    Spacer()

                    Text(sessionEvent.teacherFullName)
                        .font(.system(size: 17))
                        .italic()
                }
            }
            .foregroundColor(colorScheme == .light ? .black : .white)
            .padding(15)
            .opacity(sessionEvent.date.passed() ? 0.5 : 1)
            .background(getBackground())
        }
        .background(colorScheme == .light ? Color.white : Color.gray.opacity(appSettings.currentAppStyle == .fill ? 0.3 : 0.2))
        .cornerRadius(10)
        .padding(.horizontal, 13)
        .shadow(color: colorScheme == .light ?
            .gray.opacity(0.3) :
                .white.opacity(0.2),
                radius: 3,
                x: 0,
                y: 0)
    }

    private func getBackground() -> AnyView {
        switch appSettings.currentAppStyle {
        case .fill:
            AnyView(
                getEventColor().opacity(sessionEvent.date.isAroundNow() ? 0.5 : 0.3)
            )
        case .bordered:
            AnyView(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(getEventColor().opacity(0.5), lineWidth: 7)
            )
        }
    }

    private func getEventColor() -> Color {
        if sessionEvent.date.passed() {
            .gray
        } else {
            if sessionEvent.sessionEventType == .consultation {
                .green
            } else {
                sessionEvent.date.isAroundNow() ? .yellow : .blue
            }
        }
    }
}

#Preview {
    ScrollView {
        SessionEventSubview(sessionEvent: SessionEventDTO(title: "Иностранный язык (анг)",
                                                          date: Date.now,
                                                          sessionEventType: .exam,
                                                          teacherFullName: "Алексеева Дина Алексеевна",
                                                          cabinet: "12 корпус ауд.302"))
        .environmentObject(AppSettings())

        SessionEventSubview(sessionEvent: SessionEventDTO(title: "Иностранный язык (анг)",
                                                          date: "29 января 2025 21:00",
                                                          sessionEventType: .exam,
                                                          teacherFullName: "Алексеева Дина Алексеевна",
                                                          cabinet: "12 корпус ауд.302"))
        .environmentObject(AppSettings())

        SessionEventSubview(sessionEvent: SessionEventDTO(title: "Иностранный язык (анг)",
                                                          date: "29 января 2023 21:00",
                                                          sessionEventType: .test,
                                                          teacherFullName: "Алексеева Дина Алексеевна",
                                                          cabinet: "12 корпус ауд.302"))
        .environmentObject(AppSettings())

        SessionEventSubview(sessionEvent: SessionEventDTO(title: "Иностранный язык (анг)",
                                                          date: "29 января 2023 21:00",
                                                          sessionEventType: .testWithMark,
                                                          teacherFullName: "Алексеева Дина Алексеевна",
                                                          cabinet: "12 корпус ауд.302"))
        .environmentObject(AppSettings())
    }
}
