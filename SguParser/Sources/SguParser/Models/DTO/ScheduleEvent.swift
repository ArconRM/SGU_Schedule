//
//  ScheduleEvent.swift
//  SGU_Schedule
//
//  Created by Артемий on 23.10.2023.
//

import Foundation

public protocol ScheduleEvent: Hashable, Codable, Sendable {

    var title: String { get set }
    var weekDay: Weekdays { get set }
    var lessonNumber: Int { get set }
    var timeStart: Date { get set }
    var timeEnd: Date { get set }
}
