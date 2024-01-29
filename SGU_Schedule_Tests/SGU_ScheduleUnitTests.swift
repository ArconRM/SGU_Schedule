//
//  SGU_ScheduleUnitTests.swift
//  SGU_ScheduleTests
//
//  Created by Артемий on 27.09.2023.
//

import XCTest
import SwiftUI
@testable import SGU_Schedule

final class SGU_ScheduleUnitTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testScheduleNetworkManagerGetsCorrectHTML_shouldBeTrue() throws {
        let didReceiveResponse = expectation(description: #function)
        
        var htmlToCheck = "test initial"
        let correctHtml = try String(contentsOf: URL(string: "https://sgu.ru/schedule/knt/do/141")!, encoding: .utf8) //синхронно для теста
        
        let networkManager = LessonsNetworkManagerWithParsing(urlSource: URLSourceSGU(),
                                                              lessonParser: LessonHTMLParserSGU())
        
        networkManager.getHTML(group: GroupDTO(fullNumber: 141)) { result in
            switch result {
            case .success(let html):
                htmlToCheck = html
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 5)
        
        XCTAssertEqual(htmlToCheck, correctHtml)
    }
    
    func testHTMLParserScrapsCorrectLastUpdate_shouldBeTrue() throws {
        let sourceHtml = try String(contentsOf: URL(string: "https://sgu.ru/schedule/knt/do/141")!, encoding: .utf8) //синхронно для теста
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "dd'.'MM'.'yyyy'"
        let correctDate = dateFormatter.date(from: "15.01.2024")! //ToDo: может быть заmockать нормально
        
        let htmlParser = DateHTMLParserSGU()
        
        let dateToCheck = try htmlParser.getLastUpdateDateFromSource(source: sourceHtml)
        
        XCTAssertEqual(correctDate, dateToCheck)
    }
    
    func testHTMLParserScrapsCorrectLessons() throws { // по-хорошему надо mockать, но нужно тестирование не только декодера, но и согласованности с сайтом
        let sourceHtml = try String(contentsOf: URL(string: "https://sgu.ru/schedule/knt/do/141")!, encoding: .utf8) //синхронно для теста
            
        let htmlParser = LessonHTMLParserSGU()
        let lessons = try htmlParser.getGroupScheduleFromSource(source: sourceHtml, groupNumber: 141)
        print(lessons)
    }    
    
    func testHTMLParserScrapsCorrectSessionEvents() throws { // по-хорошему надо mockать, но нужно тестирование не только декодера, но и согласованности с сайтом
        let sourceHtml = try String(contentsOf: URL(string: "https://sgu.ru/schedule/knt/do/141")!, encoding: .utf8) //синхронно для теста
            
        let htmlParser = SessionEventsParserSGU()
        let sessionEvents = try htmlParser.getGroupSessionEventsFromSource(source: sourceHtml, groupNumber: 141)
        print(sessionEvents)
    }

    
//    func testHTMLParserScrapsCorrectGroups_shouldBeTrue() throws {
//        let urlSource = URLSourceSGU()
//        let sourceHtml = try String(contentsOf: URL(string: urlSource.baseURLAddress)!, encoding: .utf8)
//
//        let parser = GroupsHTMLParserSGU()
//        let groups = try parser.getAllGroupsFromSource(source: sourceHtml)
//        print(groups)
//    }
    
    func testHTMLParserScrapsCorrectGroupsByYearAndAcademicProgram() throws {
        let urlSource = URLSourceSGU()
        let sourceHtml = try String(contentsOf: URL(string: urlSource.baseURLAddress)!, encoding: .utf8)
        
        let parser = GroupsHTMLParserSGU()
        let groups = try parser.getGroupsByYearAndAcademicProgramFromSource(source: sourceHtml, year: 2, program: .BachelorAndSpeciality)
        print(groups)
    }
}
