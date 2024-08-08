//
//  SGU_ScheduleWidgetBundle.swift
//  SGU_ScheduleWidget
//
//  Created by Artemiy MIROTVORTSEV on 01.08.2024.
//

import WidgetKit
import SwiftUI

@main
struct SGU_ScheduleWidgetBundle: WidgetBundle {
    var body: some Widget {
        SGU_ScheduleWidget()
        SGU_ScheduleWidgetLiveActivity()
    }
}
