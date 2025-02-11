//
//  DateExtensionTests.swift
//  SGU_ScheduleTests
//
//  Created by Artemiy MIROTVORTSEV on 11.02.2025.
//

import XCTest
@testable import SGU_Schedule

final class DateExtensionTests: XCTestCase {
    var date: Date!
    var date1: Date!
    var date2: Date!
    var date3: Date!
    
    
    override func setUp() {
        super.setUp()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd HH:mm:ss"

        // Вторник, числитель
        date = dateFormatter.date(from: "2025 02 11 10:20:30") ?? dateFormatter.date(from: "00:00")!
        
        date1 = dateFormatter.date(from: "2025 02 11 09:20:30") ?? dateFormatter.date(from: "00:00")!
        
        date2 = dateFormatter.date(from: "2025 02 11 11:20:30") ?? dateFormatter.date(from: "00:00")!
        
        date3 = dateFormatter.date(from: "2025 02 10 09:20:30") ?? dateFormatter.date(from: "00:00")!
    }
    
    func testWeekday() {
        XCTAssertEqual(date.weekday, .tuesday)
    }
    
    func testCheckIfTimeIsBetweenTwoTimes() {
        XCTAssertTrue(Date.checkIfTimeIsBetweenTwoTimes(dateStart: date1, dateMiddle: date, dateEnd: date2))
    }
    
    func testCompareDatesByTime() {
        XCTAssertTrue(Date.compareDatesByTime(date1: date, date2: date3, strictInequality: false))
    }
    
    func testGetComponents() {
        XCTAssertEqual(date.getHours(), 10)
        XCTAssertEqual(date.getMinutes(), 20)
        XCTAssertEqual(date.getSeconds(), 30)
    }
    
    func testStringComponents() {
        XCTAssertEqual(date.getHoursAndMinutesString(), "10:20")
        XCTAssertEqual(date.getDayAndMonthString(), "11.02")
        XCTAssertEqual(date.getDayAndMonthWordString(), "11 февр.")
        XCTAssertEqual(date.getDayMonthAndYearString(), "11 февраля 2025")
    }
    
    func testInFuture() {
        XCTAssertTrue((.now + 60 * 60 * 24 * 2).isInFuture())
        XCTAssertFalse((.now + 60 * 60 * 24 * 2).isInFuture(days: 1))
    }
    
    func testIsToday() {
        XCTAssertTrue(Date().isToday())
        XCTAssertTrue(date.toTodayDate().isToday())
    }
    
    func testIsPassed() {
        XCTAssertTrue((.now - 60 * 60 * 2).passed(duration: 1))
        XCTAssertFalse((.now - 60 * 60 * 2).passed(duration: 4))
    }
}
