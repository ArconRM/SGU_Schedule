//
//  SGU_ScheduleWidget.swift
//  SGU_ScheduleWidget
//
//  Created by Artemiy MIROTVORTSEV on 01.08.2024.
//

import WidgetKit
import SwiftUI

struct ScheduleEventsEntry: TimelineEntry {
    var date: Date
    var fetchResultVariant: ScheduleFetchResultVariants
    var currentEvent: (any ScheduleEventDTO)?
    var nextEvent: (any ScheduleEventDTO)?
}

struct ScheduleEventsProvider: TimelineProvider {
    @ObservedObject var viewModel = ScheduleWidgetViewModel(schedulePersistenceManager: GroupScheduleCoreDataManager())
    
//    init() {
//        viewModel.fetchSavedSchedule()
//    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ScheduleEventsEntry>) -> Void) {
        let date = Date()
        viewModel.fetchSavedSchedule()
        
        let resultVariant = viewModel.fetchResult.resultVariant
        let currentEvent = viewModel.fetchResult.currentEvent
        let nextLesson = viewModel.fetchResult.nextLesson
        
        let entry = ScheduleEventsEntry(
            date: date, 
            fetchResultVariant: resultVariant,
            currentEvent: currentEvent,
            nextEvent: nextLesson
        )
        
        var nextUpdateDate = date
        // Если сейчас что-то есть, то обновляем после окончания
        if currentEvent != nil {
            nextUpdateDate = Calendar.current.date(bySettingHour: currentEvent!.timeEnd.getHours(), minute: currentEvent!.timeEnd.getMinutes() + 1, second: 0, of: date)!
        } else { // Если сейчас ничего нет (значит дальше тоже ничего нет, ибо тогда была бы перемена), значит обновляем утром
            let morningUpdateDate = Calendar.current.date(bySettingHour: 8, minute: 20, second: 0, of: date)!
            // Если сейчас не позже чем 8:20
            if morningUpdateDate <= date {
                nextUpdateDate = morningUpdateDate
            } else { // Если позже, то обновляем уже на утро следующего дня
                nextUpdateDate = Calendar.current.date(byAdding: .day, value: 1, to: morningUpdateDate)!
            }
        }
        
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
    
    var fetchResultVariant: ScheduleFetchResultVariants
    var currentEvent: (any ScheduleEventDTO)?
    var nextEvent: (any ScheduleEventDTO)?

    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall: 
            CurrentScheduleEventView(
                fetchResultVariant: fetchResultVariant,
                currentEvent: currentEvent
            )
            .containerBackground(for: .widget) {
                getBackground(event: currentEvent)
            }
        case .systemMedium:
            CurrentAndNextScheduleEventsView(
                fetchResultVariant: fetchResultVariant,
                currentEvent: currentEvent,
                nextEvent: nextEvent
            )
            .containerBackground(for: .widget) {
                getBackground(event: currentEvent)
            }
        default:
            NotAvailableView()
        }
    }
    
    private func getBackground(event: (any ScheduleEventDTO)?) -> some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(colorScheme == .light ? .white : .gray.opacity(0.2))
            .stroke(getBackgroundColor(event: event), lineWidth: 4)
            .padding(2)
    }
    
    private func getBackgroundColor(event: (any ScheduleEventDTO)?) -> Color {
        if event == nil {
            return .gray
        } else if let lesson = event as? LessonDTO {
            return lesson.lessonType == .Lecture ?
            AppTheme.green.foregroundColor(colorScheme: colorScheme) :
            AppTheme.blue.foregroundColor(colorScheme: colorScheme)
        }
        
        return .gray
    }
}

struct SGU_ScheduleWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: "SGU_ScheduleWidget",
            provider: ScheduleEventsProvider()
        ) { entry in
            ScheduleEventsView(
                fetchResultVariant: entry.fetchResultVariant,
                currentEvent: entry.currentEvent,
                nextEvent: entry.nextEvent)
        }
        .configurationDisplayName("Расписание")
        .description("Показывает текущую и следующие пары")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}


struct Widget_Previews: PreviewProvider {
    
    static var previews: some View {
        let currentEvent = LessonDTO(subject: "Линейная алгебра",
                                     teacherFullName: "Бредихин Д. А.",
                                     teacherEndpoint: "/person/bredihin-dmitriy-aleksandrovich",
                                     lessonType: .Lecture,
                                     weekDay: .Monday,
                                     weekType: .Numerator,
                                     cabinet: "12 корпус ауд.303",
                                     lessonNumber: 1,
                                     timeStart: "08:20",
                                     timeEnd: "09:50")
        
        let nextEvent = LessonDTO(subject: "Хуйня на постном масле",
                                  teacherFullName: "Бредихин Д. А.",
                                  lessonType: .Practice,
                                  weekDay: .Monday,
                                  weekType: .Denumerator,
                                  cabinet: "12 корпус ауд.304",
                                  lessonNumber: 1,
                                  timeStart: "10:00",
                                  timeEnd: "11:30")
        Group {
            ScheduleEventsView(
                fetchResultVariant: .Success,
                currentEvent: currentEvent,
                nextEvent: nextEvent
            )
                .previewContext(WidgetPreviewContext(family: .systemMedium))
        }
    }
}
