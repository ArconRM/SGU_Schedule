//
//  SessionEventSubview.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.01.2024.
//

import SwiftUI
import SguParser

struct SessionEventSubview: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appearanceSettings: AppearanceSettingsStore

    let sessionEvent: SessionEventDTO

    var body: some View {
        Group {
            if #available(iOS 26, *) {
                content
            } else {
                content
                    .background(colorScheme == .light ? Color.white : Color.gray.opacity(appearanceSettings.currentAppStyle == .fill ? 0.3 : 0.2))
                    .cornerRadius(10)
                    .shadow(
                        color: colorScheme == .light ? .gray.opacity(0.3) : .white.opacity(0.2),
                        radius: 3,
                        x: 0,
                        y: 0
                    )
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        VStack {
            makeSingleSessionView(sessionEvent: sessionEvent)
        }
    }

    private func makeSingleSessionView(sessionEvent: SessionEventDTO, withChevron: Bool = false) -> some View {
        Group {
            if #available(iOS 26, *) {
                sessionEventContent(sessionEvent: sessionEvent, withChevron: withChevron)
                    .padding(20)
                    .background {
                        if appearanceSettings.currentAppStyle != .bordered {
                            getSessionBackground(sessionEvent: sessionEvent)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .opacity(sessionEvent.date.passed(duration: Date.getDurationHours(sessionEventType: sessionEvent.sessionEventType)) ? 0.5 : 1)
                    .glassEffect(
                        .regular.interactive(),
                        in: RoundedRectangle(cornerRadius: 20)
                    )
            } else {
                sessionEventContent(sessionEvent: sessionEvent, withChevron: withChevron)
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .padding(15)
                    .opacity(sessionEvent.date.passed(duration: Date.getDurationHours(sessionEventType: sessionEvent.sessionEventType)) ? 0.5 : 1)
                    .background(getSessionBackground(sessionEvent: sessionEvent))
            }
        }
    }

    @ViewBuilder
    private func sessionEventContent(sessionEvent: SessionEventDTO, withChevron: Bool = false) -> some View {
        VStack(spacing: 12) {
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
    }

    private func getSessionBackground(sessionEvent: SessionEventDTO) -> AnyView {
        switch appearanceSettings.currentAppStyle {
        case .fill:
            AnyView(
                getSessionColor(sessionEvent: sessionEvent).opacity(0.3)
            )
        case .bordered:
            AnyView(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(getSessionColor(sessionEvent: sessionEvent).opacity(0.5), lineWidth: 7)
            )
        }
    }

    private func getSessionColor(sessionEvent: SessionEventDTO) -> Color {
        if sessionEvent.date.passed(duration: Date.getDurationHours(sessionEventType: sessionEvent.sessionEventType)) {
            return .gray
        } else {
            if sessionEvent.sessionEventType == .consultation {
                return .green
            } else {
                return sessionEvent.date.isToday() ? .yellow : .blue
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
        .environmentObject(AppearanceSettingsStore())

        SessionEventSubview(sessionEvent: SessionEventDTO(title: "Иностранный язык (анг)",
                                                          date: "29 января 2026 21:00",
                                                          sessionEventType: .exam,
                                                          teacherFullName: "Алексеева Дина Алексеевна",
                                                          cabinet: "12 корпус ауд.302"))
        .environmentObject(AppearanceSettingsStore())

        SessionEventSubview(sessionEvent: SessionEventDTO(title: "Иностранный язык (анг)",
                                                          date: "29 января 2026 21:00",
                                                          sessionEventType: .consultation,
                                                          teacherFullName: "Алексеева Дина Алексеевна",
                                                          cabinet: "12 корпус ауд.302"))
        .environmentObject(AppearanceSettingsStore())

        SessionEventSubview(sessionEvent: SessionEventDTO(title: "Иностранный язык (анг)",
                                                          date: "29 января 2023 21:00",
                                                          sessionEventType: .testWithMark,
                                                          teacherFullName: "Алексеева Дина Алексеевна",
                                                          cabinet: "12 корпус ауд.302"))
        .environmentObject(AppearanceSettingsStore())
    }
}
