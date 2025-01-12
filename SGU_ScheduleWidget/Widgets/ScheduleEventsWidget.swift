//
//  ScheduleEventsWidget.swift
//  SGU_ScheduleWidget
//
//  Created by Artemiy MIROTVORTSEV on 01.08.2024.
//

import WidgetKit
import SwiftUI

struct ScheduleEventsEntry: TimelineEntry {
    let date: Date
    let fetchResultVariant: ScheduleEventsFetchResult
    let closeLesson: LessonDTO?
}

struct ScheduleEventsProvider: TimelineProvider {
    @ObservedObject var viewModel = ScheduleEventsWidgetViewModel(schedulePersistenceManager: GroupScheduleCoreDataManager(), lessonSubgroupsPersistenceManager: LessonSubgroupsUDManager())

    func getTimeline(in context: Context, completion: @escaping (Timeline<ScheduleEventsEntry>) -> Void) {
        let date = Date()
        viewModel.fetchSavedSchedule()

        let resultVariant = viewModel.fetchResult
        let firstLesson = viewModel.fetchResult.firstLesson
        let currentEvent = viewModel.fetchResult.currentEvent
        let nextLesson = viewModel.fetchResult.nextLesson
        var closeLesson: LessonDTO?

        var nextUpdateDate = date

        if firstLesson == nil { // Если сегодня нет пар  - обновляем на следующий учебный день
            let morningUpdateDate = Calendar.current.date(bySettingHour: 6, minute: 0, second: 5, of: date) ?? date
            nextUpdateDate = Calendar.current.date(byAdding: .day, value: Date.currentWeekday == .saturday ? 2 : 1, to: morningUpdateDate) ?? date

        } else if currentEvent != nil { // Если сейчас что-то есть, то обновляем после окончания текущего
            nextUpdateDate = Calendar.current.date(bySettingHour: currentEvent!.timeEnd.getHours(), minute: currentEvent!.timeEnd.getMinutes(), second: 5, of: date) ?? date

        } else if date.getHours() <= firstLesson!.timeStart.getHours() { // Если сейчас ничего нет и время сейчас до первой пары
            if firstLesson!.timeStart.getHours() - date.getHours() <= 2 { // Если первая пара ближе, чем через 2 часа, ставим что она скоро и обновляем когда она начнется
                closeLesson = firstLesson!
                nextUpdateDate = Calendar.current.date(bySettingHour: firstLesson!.timeStart.getHours(), minute: firstLesson!.timeStart.getMinutes(), second: 5, of: date) ?? date
            } else { // Иначе обновляем за два часа до первой
                nextUpdateDate = Calendar.current.date(bySettingHour: firstLesson!.timeStart.getHours() - 2, minute: firstLesson!.timeStart.getMinutes(), second: 5, of: date) ?? date
            }

        } else if date.getHours() > firstLesson!.timeStart.getHours() { // Если сейчас ничего нет и время позже первой пары, значит сегодня больше ничего нет и обновляем на след учебный день
            let morningUpdateDate = Calendar.current.date(bySettingHour: 6, minute: 0, second: 5, of: date) ?? date
            nextUpdateDate = Calendar.current.date(byAdding: .day, value: Date.currentWeekday == .saturday ? 2 : 1, to: morningUpdateDate) ?? date
        }

        let entry = ScheduleEventsEntry(
            date: date,
            fetchResultVariant: resultVariant,
            closeLesson: closeLesson
        )

        let timeline = Timeline(
            entries: [entry],
            policy: .after(nextUpdateDate)
        )

        completion(timeline)
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let date = Date()
        let entry: ScheduleEventsEntry

        if context.isPreview && !viewModel.fetchResult.isSuccess {
            entry = ScheduleEventsEntry(
                date: date,
                fetchResultVariant: .success(currentEvent: nil, firstLesson: nil, nextLesson: nil),
                closeLesson: nil
            )
        } else {
            entry = ScheduleEventsEntry(
                date: date,
                fetchResultVariant: viewModel.fetchResult,
                closeLesson: nil
            )
        }

        completion(entry)
    }

    func placeholder(in context: Context) -> ScheduleEventsEntry {
        let date = Date()

        return ScheduleEventsEntry(
            date: date,
            fetchResultVariant: .success(currentEvent: nil, firstLesson: nil, nextLesson: nil),
            closeLesson: nil
        )
    }
}

struct ScheduleEventsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.widgetFamily) var family: WidgetFamily
    @EnvironmentObject var appSettings: AppSettings

    var fetchResult: ScheduleEventsFetchResult
    var closeLesson: LessonDTO?

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            SingleScheduleEventView(
                fetchResult: fetchResult,
                closeLesson: closeLesson
            )
            .environmentObject(appSettings)
            .containerBackground(for: .widget) {
                if appSettings.currentAppStyle == AppStyle.fill {
                    buildFilledRectangle()
                } else {
                    buildBorderedRectangle()
                }
            }
            .widgetURL(URL(string: AppUrls.isOpenedFromScheduleWidget.rawValue)!)

        case .systemMedium:
            TwoScheduleEventsView(
                fetchResult: fetchResult,
                closeLesson: closeLesson
            )
            .environmentObject(appSettings)
            .containerBackground(for: .widget) {
                if appSettings.currentAppStyle == AppStyle.fill {
                    buildFilledRectangle()
                } else {
                    buildBorderedRectangle()
                }
            }
            .widgetURL(URL(string: AppUrls.isOpenedFromScheduleWidget.rawValue)!)

        case .accessoryRectangular:
            AccessoryRectangularScheduleView(
                fetchResult: fetchResult,
                closeLesson: closeLesson
            )
            .containerBackground(.clear, for: .widget)
            .widgetURL(URL(string: AppUrls.isOpenedFromScheduleWidget.rawValue)!)

        case .accessoryInline:
            AccessoryScheduleInlineView(
                fetchResult: fetchResult,
                closeLesson: closeLesson
            )
            .containerBackground(.clear, for: .widget)
            .widgetURL(URL(string: AppUrls.isOpenedFromScheduleWidget.rawValue)!)

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
            Color.black.opacity(colorScheme == .light ? 0.8 : 0.6)
            appSettings.currentAppTheme.backgroundColor(colorScheme: colorScheme)
                .cornerRadius(20)
                .padding(4)
                .blur(radius: 2)
        }
    }

    private func buildBorderedRectangle() -> some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(appSettings.currentAppTheme.foregroundColor(colorScheme: colorScheme).opacity(0.4), lineWidth: 4)
            .padding(2)
    }
}

struct ScheduleEventsWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "ScheduleEventsWidget",
            provider: ScheduleEventsProvider()
        ) { entry in
            ScheduleEventsView(
                fetchResult: entry.fetchResultVariant,
                closeLesson: entry.closeLesson
            )
            .environmentObject(AppSettings())
        }
        .configurationDisplayName("Расписание пар")
        .description("Показывает текущие пары")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .accessoryRectangular,
            .accessoryInline
        ])
    }
}

struct ScheduleEventsWidget_Previews: PreviewProvider {

    static var previews: some View {
        let lesson = LessonDTO(subject: "Иностранный язык",
                               teacherFullName: "Бредихин Д. А.",
                               teacherEndpoint: "/person/bredihin-dmitriy-aleksandrovich",
                               lessonType: .lecture,
                               weekDay: .monday,
                               weekType: .numerator,
                               cabinet: "12 корпус ауд.303",
                               lessonNumber: 1,
                               timeStart: "08:20",
                               timeEnd: "09:50")

        let nextLesson = LessonDTO(subject: "Дифференциальные уравнения и еще что-нибудь для длины",
                                  teacherFullName: "Бредихин Д. А.",
                                  lessonType: .practice,
                                  weekDay: .monday,
                                  weekType: .denumerator,
                                  cabinet: "12 корпус ауд.304",
                                  lessonNumber: 1,
                                  timeStart: "10:00",
                                  timeEnd: "11:30")
        Group {
            ScheduleEventsView(
                fetchResult: .success(currentEvent: lesson, firstLesson: nil, nextLesson: nil),
                closeLesson: nextLesson
            )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .environmentObject(AppSettings())

            ScheduleEventsView(
                fetchResult: .success(currentEvent: lesson, firstLesson: nil, nextLesson: nextLesson),
                closeLesson: nextLesson
            )
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .environmentObject(AppSettings())

            ScheduleEventsView(
                fetchResult: .success(currentEvent: lesson, firstLesson: nil, nextLesson: nil),
                closeLesson: nil
            )
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .environmentObject(AppSettings())
        }
    }
}
