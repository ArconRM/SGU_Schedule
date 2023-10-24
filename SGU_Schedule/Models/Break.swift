//
//  TimeBreak.swift
//  SGU_Schedule
//
//  Created by Артемий on 23.10.2023.
//

import Foundation

public struct TimeBreak: Event {
    
    public var id: UUID
    public var title: String = "Перемена"
    public var timeStart: Date
    public var timeEnd: Date
    
    init(timeStart: Date, timeEnd: Date) {
        self.id = UUID()
        self.timeStart = timeStart
        self.timeEnd = timeEnd
    }
}
