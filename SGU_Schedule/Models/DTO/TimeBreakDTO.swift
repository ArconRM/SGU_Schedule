//
//  TimeBreakDTO.swift
//  SGU_Schedule
//
//  Created by Артемий on 23.10.2023.
//

import Foundation

public struct TimeBreakDTO: ScheduleEventDTO {
    
    public var title: String = "Перемена"
    public var timeStart: Date
    public var timeEnd: Date
    
    init(timeStart: Date, timeEnd: Date) {
        self.timeStart = timeStart
        self.timeEnd = timeEnd
    }
    
    /// TimeStart and TimeEnd must be in "HH:mm" format
    init(timeStart: String, timeEnd: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        self.timeStart = dateFormatter.date(from: timeStart) ?? dateFormatter.date(from: "00:00")!
        self.timeEnd = dateFormatter.date(from: timeEnd) ?? dateFormatter.date(from: "00:00")!
    }
}
