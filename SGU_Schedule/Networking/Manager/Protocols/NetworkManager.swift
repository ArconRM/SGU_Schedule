//
//  NetworkManager.swift
//  SGU_Schedule
//
//  Created by Артемий on 23.09.2023.
//

import Foundation

public protocol NetworkManager {
    var urlResource: URLSource { get set }
    func getScheduleForDay(group: Group, day: Weekdays, isNumerator: Bool, completionHandler: @escaping(Result<[[Lesson]], Error>) -> Void)
    func getScheduleForCurrentWeek(group: Group, isNumerator: Bool, completionHandler: @escaping(Result<[[[Lesson]]], Error>) -> Void)
    func getLastUpdateDate(group: Group, completionHandler: @escaping(Result<Date, Error>) -> Void)
}
