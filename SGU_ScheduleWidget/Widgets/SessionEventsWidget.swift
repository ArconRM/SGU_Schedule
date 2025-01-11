//
//  SessionEventsWidget.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 08.01.2025.
//

import WidgetKit
import SwiftUI

struct SessionEventsEntry: TimelineEntry {
    let date: Date
    let fetchResult: SessionEventsFetchResult
}

struct SessionEventsProvider: TimelineProvider {
    @ObservedObject var viewModel = SessionEventsWidgetViewModel(sessionEventsPersistenceManager: GroupSessionEventsCoreDataManager())

    func getTimeline(in context: Context, completion: @escaping (Timeline<SessionEventsEntry>) -> Void) {
        viewModel.fetchSavedSessionEvents()

        let date = Date()
        let morningUpdateDate = Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: date) ?? date
        let nearestMorningUpdateDate = Calendar.current.date(byAdding: .day, value: date.getHours() >= 6 ? 1 : 0, to: morningUpdateDate) ?? date

        let entry = SessionEventsEntry(
            date: date,
            fetchResult: viewModel.fetchResult
        )

        let timeline = Timeline(
            entries: [entry],
            policy: .after(nearestMorningUpdateDate)
        )

        completion(timeline)
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let date = Date()
        let entry: SessionEventsEntry

        if context.isPreview && !viewModel.fetchResult.isSuccess {
            entry = SessionEventsEntry(
                date: date,
                fetchResult: .success(consultation: nil, exam: nil)
            )
        } else {
            entry = SessionEventsEntry(
                date: date,
                fetchResult: viewModel.fetchResult
            )
        }

        completion(entry)
    }

    func placeholder(in context: Context) -> SessionEventsEntry {
        let date = Date()

        return SessionEventsEntry(
            date: date,
            fetchResult: .success(consultation: nil, exam: nil)
        )
    }
}

struct SessionEventsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.widgetFamily) var family: WidgetFamily
    @EnvironmentObject var appSettings: AppSettings

    var fetchResult: SessionEventsFetchResult

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            SingleSessionEventView(fetchResult: fetchResult)
                .environmentObject(appSettings)
                .containerBackground(for: .widget) {
                    if appSettings.currentAppStyle == AppStyle.fill {
                        buildFilledRectangle()
                    } else {
                        buildBorderedRectangle()
                    }
                }
                .widgetURL(URL(string: AppUrls.isOpenedFromSessionWidget.rawValue)!)

        case .systemMedium:
            TwoSessionEventsView(fetchResult: fetchResult)
                .environmentObject(appSettings)
                .containerBackground(for: .widget) {
                    if appSettings.currentAppStyle == AppStyle.fill {
                        buildFilledRectangle()
                    } else {
                        buildBorderedRectangle()
                    }
                }
                .widgetURL(URL(string: AppUrls.isOpenedFromSessionWidget.rawValue)!)

        default:
            NotAvailableView()
                .environmentObject(appSettings)
                .containerBackground(for: .widget) {
                    if appSettings.currentAppStyle == AppStyle.fill {
                        buildFilledRectangle()
                    } else {
                        buildBorderedRectangle()
                    }
                }
        }
    }

    private func buildFilledRectangle() -> some View {
        ZStack {
            Color.black.opacity(colorScheme == .light ? 0.8 : 1)
            appSettings.currentAppTheme.backgroundColor(colorScheme: colorScheme).opacity(0.8)
                .cornerRadius(18)
                .padding(4)
                .blur(radius: 20)
        }
    }

    private func buildBorderedRectangle() -> some View {
        RoundedRectangle(cornerRadius: 18)
            .stroke(appSettings.currentAppTheme.foregroundColor(colorScheme: colorScheme).opacity(0.4), lineWidth: 4)
            .padding(2)
    }
}

struct SessionEventsWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "SessionEventsWidget",
            provider: SessionEventsProvider()
        ) { entry in
            SessionEventsView(fetchResult: entry.fetchResult)
                .environmentObject(AppSettings())
        }
        .configurationDisplayName("Расписание сессии")
        .description("Показывает ближайшие консультации и экзамены")
        .supportedFamilies([
            .systemSmall,
            .systemMedium
        ])
    }
}

struct SessionEventsWidget_Previews: PreviewProvider {

    static var previews: some View {
        let consultation = SessionEventDTO(
            title: "Теория вероятности и математическая статистика",
            date: Date.now.addingTimeInterval(-100000),
            sessionEventType: .consultation,
            teacherFullName: "Сергеева Надежда Викторовна",
            cabinet: "дистанционно"
        )
        let exam = SessionEventDTO(
            title: "Теория вероятности и математическая статистика",
            date: Date.now.addingTimeInterval(100000),
            sessionEventType: .exam,
            teacherFullName: "Сергеева Надежда Викторовна",
            cabinet: "12 корпус ауд. 403"
        )

        Group {
            SessionEventsView(fetchResult: .success(consultation: consultation, exam: exam))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .environmentObject(AppSettings())

            SessionEventsView(fetchResult: .success(consultation: consultation, exam: exam))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environmentObject(AppSettings())
        }
    }
}
