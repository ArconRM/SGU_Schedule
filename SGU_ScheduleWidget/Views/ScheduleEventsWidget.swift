//
//  ScheduleEventsWidget.swift
//  SGU_ScheduleWidget
//
//  Created by Artemiy MIROTVORTSEV on 01.08.2024.
//

import WidgetKit
import SwiftUI

struct ScheduleEventsEntry: TimelineEntry {
    var date: Date
    var fetchResultVariant: ScheduleFetchResultVariants
    var currentEvent: (any ScheduleEvent)?
    var nextEvent: (any ScheduleEvent)?
    var closeLesson: LessonDTO?
}

struct ScheduleEventsProvider: TimelineProvider {
    @ObservedObject var viewModel = ScheduleWidgetViewModel(schedulePersistenceManager: GroupScheduleCoreDataManager(), lessonSubgroupsPersistenceManager: LessonSubgroupsUDManager())
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ScheduleEventsEntry>) -> Void) {
        let date = Date()
        viewModel.fetchSavedSchedule()
        
        let resultVariant = viewModel.fetchResult.resultVariant
        let firstLesson = viewModel.fetchResult.firstLesson
        let currentEvent = viewModel.fetchResult.currentEvent
        let nextLesson = viewModel.fetchResult.nextLesson
        var closeLesson: LessonDTO? = nil
        
        var nextUpdateDate = date
        
        if firstLesson == nil { // Если сегодня нет пар  - обновляем на следующий учебный день
            let morningUpdateDate = Calendar.current.date(bySettingHour: 6, minute: 0, second: 5, of: date) ?? date
            nextUpdateDate = Calendar.current.date(byAdding: .day, value: Date.currentWeekDay == .saturday ? 2 : 1, to: morningUpdateDate) ?? date
            
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
            nextUpdateDate = Calendar.current.date(byAdding: .day, value: Date.currentWeekDay == .saturday ? 2 : 1, to: morningUpdateDate) ?? date
        }
        
        let entry = ScheduleEventsEntry(
            date: date,
            fetchResultVariant: resultVariant,
            currentEvent: currentEvent,
            nextEvent: nextLesson,
            closeLesson: closeLesson
        )
        
        let timeline = Timeline(
            entries:[entry],
            policy: .after(nextUpdateDate)
        )
        
        completion(timeline)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let date = Date()
        let entry: ScheduleEventsEntry

        if context.isPreview && viewModel.fetchResult.resultVariant != .Success {
            entry = ScheduleEventsEntry(
                date: date,
                fetchResultVariant: .Success
            )
        } else {
            entry = ScheduleEventsEntry(
                date: date,
                fetchResultVariant: viewModel.fetchResult.resultVariant,
                currentEvent: viewModel.fetchResult.currentEvent,
                nextEvent: viewModel.fetchResult.nextLesson
            )
        }
        
        completion(entry)
    }
    
    
    func placeholder(in context: Context) -> ScheduleEventsEntry {
        let date = Date()
        
        return ScheduleEventsEntry(
            date: date,
            fetchResultVariant: .Success
        )
    }
}

struct ScheduleEventsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.widgetFamily) var family: WidgetFamily
    @EnvironmentObject var appSettings: AppSettings
    
    var fetchResultVariant: ScheduleFetchResultVariants
    var currentEvent: (any ScheduleEvent)?
    var nextEvent: (any ScheduleEvent)?
    var closeLesson: LessonDTO?

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall: 
            SingleScheduleEventView(
                fetchResultVariant: fetchResultVariant,
                currentEvent: currentEvent,
                closeLesson: closeLesson
            )
            .environmentObject(appSettings)
            .containerBackground(for: .widget) {
                if appSettings.currentAppStyle == AppStyle.fill {
                    buildFilledRectangle(event: currentEvent)
                } else {
                    buildBorderedRectangle(event: currentEvent)
                }
            }
            .widgetURL(URL(string: AppUrls.openedFromWidget.rawValue)!)
            
        case .systemMedium:
            TwoScheduleEventsView(
                fetchResultVariant: fetchResultVariant,
                currentEvent: currentEvent,
                nextEvent: nextEvent,
                closeLesson: closeLesson
            )
            .environmentObject(appSettings)
            .containerBackground(for: .widget) {
                if appSettings.currentAppStyle == AppStyle.fill {
                    buildFilledRectangle(event: currentEvent)
                } else {
                    buildBorderedRectangle(event: currentEvent)
                }
            }
            .widgetURL(URL(string: AppUrls.openedFromWidget.rawValue)!)
            
        case .accessoryRectangular:
            AccessoryRectangularScheduleView(
                fetchResultVariant: fetchResultVariant,
                currentEvent: currentEvent,
                closeLesson: closeLesson
            )
            .containerBackground(.clear, for: .widget)
            .widgetURL(URL(string: AppUrls.openedFromWidget.rawValue)!)
            
        case .accessoryInline:
            AccessoryScheduleInlineView(
                fetchResultVariant: fetchResultVariant,
                currentEvent: currentEvent,
                closeLesson: closeLesson
            )
            .containerBackground(.clear, for: .widget)
            .widgetURL(URL(string: AppUrls.openedFromWidget.rawValue)!)
            
        default:
            NotAvailableView()
        }
    }
    
    private func buildFilledRectangle(event: (any ScheduleEvent)?) -> some View {
        ZStack {
            Color.black.opacity(colorScheme == .light ? 0.8 : 1)
            getBackgroundColor(event: event).opacity(0.3)
                .cornerRadius(18)
                .padding(4)
                .blur(radius: 20)
            RoundedRectangle(cornerRadius: 18)
                .fill(getBackgroundColor(event: event).opacity(0.5))
        }
    }
    
    private func buildBorderedRectangle(event: (any ScheduleEvent)?) -> some View {
        RoundedRectangle(cornerRadius: 18)
            .stroke(getBackgroundColor(event: event), lineWidth: 4)
            .padding(2)
    }
    
    private func getBackgroundColor(event: (any ScheduleEvent)?) -> Color {
        if event == nil {
            return .gray.opacity(0.7)
        } else if let lesson = event as? LessonDTO {
            return lesson.lessonType == .lecture ?
            AppTheme.green.foregroundColor(colorScheme: colorScheme) :
            AppTheme.blue.foregroundColor(colorScheme: colorScheme)
        }
        
        return .gray
    }
}

struct ScheduleEventsWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "SGU_ScheduleWidget",
            provider: ScheduleEventsProvider()
        ) { entry in
            ScheduleEventsView(
                fetchResultVariant: entry.fetchResultVariant,
                currentEvent: entry.currentEvent,
                nextEvent: entry.nextEvent,
                closeLesson: entry.closeLesson
            )
            .environmentObject(AppSettings())
        }
        .configurationDisplayName("Расписание")
        .description("Показывает текущие пары")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .accessoryRectangular,
            .accessoryInline
        ])
    }
}


struct Widget_Previews: PreviewProvider {
    
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
        
        let nextEvent = LessonDTO(subject: "Дифференциальные уравнения и еще что-нибудь для длины",
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
                fetchResultVariant: .Success,
                currentEvent: lesson,
                nextEvent: nil,
                closeLesson: nextEvent
            )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environmentObject(AppSettings())
            
            ScheduleEventsView(
            fetchResultVariant: .Success,
            currentEvent: lesson,
            nextEvent: nextEvent,
            closeLesson: nextEvent
        )
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .environmentObject(AppSettings())
            
            ScheduleEventsView(
            fetchResultVariant: .Success,
            currentEvent: lesson,
            nextEvent: nil,
            closeLesson: nil
        )
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
            .environmentObject(AppSettings())
        }
    }
}
