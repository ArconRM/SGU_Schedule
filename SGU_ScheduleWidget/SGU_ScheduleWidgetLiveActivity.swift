//
//  SGU_ScheduleWidgetLiveActivity.swift
//  SGU_ScheduleWidget
//
//  Created by Artemiy MIROTVORTSEV on 01.08.2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SGU_ScheduleWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SGU_ScheduleWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SGU_ScheduleWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension SGU_ScheduleWidgetAttributes {
    fileprivate static var preview: SGU_ScheduleWidgetAttributes {
        SGU_ScheduleWidgetAttributes(name: "World")
    }
}

extension SGU_ScheduleWidgetAttributes.ContentState {
    fileprivate static var smiley: SGU_ScheduleWidgetAttributes.ContentState {
        SGU_ScheduleWidgetAttributes.ContentState(emoji: "😀")
     }

     fileprivate static var starEyes: SGU_ScheduleWidgetAttributes.ContentState {
         SGU_ScheduleWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: SGU_ScheduleWidgetAttributes.preview) {
   SGU_ScheduleWidgetLiveActivity()
} contentStates: {
    SGU_ScheduleWidgetAttributes.ContentState.smiley
    SGU_ScheduleWidgetAttributes.ContentState.starEyes
}
