//
//  ScheduleLiveActivity.swift
//  SGU_ScheduleLiveActivities
//
//  Created by Artemiy MIROTVORTSEV on 10.02.2025.
//


import ActivityKit
import WidgetKit
import SwiftUI

struct ScheduleLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ScheduleEventAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                HStack {
                    Text(context.state.lessonTitle)
                        .font(.system(size: 17, weight: .bold))
                        .multilineTextAlignment(.leading)
                        .bold()
                    
                    Spacer()
                    
                    Text(context.state.timeStart.getHoursAndMinutesString() + " - " + context.state.timeEnd.getHoursAndMinutesString())
                        .font(.system(size: 17, weight: .regular))
                        .multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text(context.state.lessonType.rawValue)
                        .font(.system(size: 13, weight: .light))
                        .multilineTextAlignment(.leading)
                        .bold()
                    
                    Spacer()
                }
                
                HStack {
                    Text(context.state.teacherFullName)
                        .font(.system(size: 15, weight: .bold))
                        .padding(.top, 2)
                    
                    Spacer()
                    
                    Text(context.state.cabinet)
                        .font(.system(size: 15, weight: .regular))
                        .padding(.top, 2)
                }
            }
            .foregroundColor(.white)
            .activityBackgroundTint(Color.gray.opacity(0.5))
            .padding(.vertical, 15)
            .padding(.horizontal, 15)
            .widgetURL(URL(string: AppUrls.isOpenedFromScheduleWidget.rawValue))

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text(context.state.timeStart.getHoursAndMinutesString())
                        .padding(.leading, 2)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.timeEnd.getHoursAndMinutesString())
                        .padding(.trailing, 2)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack {
                        Text(context.state.lessonTitle)
                            .font(.system(size: 17, weight: .bold))
                        
                        Text(context.state.cabinet)
                            .font(.system(size: 15, weight: .light))
                    }
                    .padding(.top, 2)
                }
            } compactLeading: {
                Text(context.state.lessonTitle)
            } compactTrailing: {
                Text("до \(context.state.timeEnd.getHoursAndMinutesString())")
            } minimal: {
                Text(context.state.timeEnd.getHoursAndMinutesString())
            }
        }
    }
}

extension ScheduleEventAttributes {
    fileprivate static var preview: ScheduleEventAttributes {
        ScheduleEventAttributes()
    }
}
