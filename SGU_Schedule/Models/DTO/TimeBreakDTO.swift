//
//  TimeBreakDTO.swift
//  SGU_Schedule
//
//  Created by Артемий on 23.10.2023.
//

import Foundation

public struct TimeBreakDTO: ScheduleEventDTO {
    
//    public var id: UUID
    public var title: String = "Перемена"
    public var timeStart: Date
    public var timeEnd: Date
    
    init(timeStart: Date, timeEnd: Date) {
//        self.id = UUID()
        self.timeStart = timeStart
        self.timeEnd = timeEnd
    }
    
    init(timeStart: String, timeEnd: String) {
//        self.id = UUID()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "HH:mm"
        
        self.timeStart = dateFormatter.date(from: timeStart) ?? dateFormatter.date(from: "00:00")!
        self.timeEnd = dateFormatter.date(from: timeEnd) ?? dateFormatter.date(from: "00:00")!
    }
}
