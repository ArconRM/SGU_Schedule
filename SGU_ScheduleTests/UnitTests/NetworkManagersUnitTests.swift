//
//  NetworkManagersUnitTests.swift
//  SGU_ScheduleTests
//
//  Created by Артемий on 05.02.2024.
//

import XCTest
import SwiftUI
@testable import SGU_Schedule 

final class NetworkManagersUnitTests: XCTestCase {
    
    let urlSource = URLSourceSGU()

    override func setUpWithError() throws {
        super.setUp()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLessonNetworkManagerWithParsingGetsSchedule() {
        let didReceiveResponse = expectation(description: #function)
        
        let lessonParser = LessonParserForTest()
        var scheduleToCheck: GroupScheduleDTO?
        var correctSchedule: GroupScheduleDTO?
        do {
            correctSchedule = try lessonParser.getGroupScheduleFromSource(source: "", groupNumber: "141", departmentCode: "knt")
            XCTAssertNotNil(correctSchedule)
        }
        catch {
            XCTFail("Если упадет здесь, следующим упаду я из окна")
        }
        
        let lessonNetworkManager = LessonNetworkManagerWithParsing(urlSource: urlSource, lessonParser: lessonParser, scraper: StaticScraper())
        lessonNetworkManager.getGroupScheduleForCurrentWeek(group: AcademicGroupDTO(fullNumber: "141", departmentCode: "knt")) { result in
            switch result {
            case .success(let schedule):
                scheduleToCheck = schedule
            case .failure(let error):
                XCTFail("Ошибка в менеджере: \(error.localizedDescription)")
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 5)
        
        XCTAssertNotNil(scheduleToCheck)
        XCTAssertEqual(scheduleToCheck!.lessons, correctSchedule!.lessons)
    }

//    func testDateNetworkManageWithParsingGetsUpdateDate() {
//        let didReceiveResponse = expectation(description: #function)
//        
//        let dateParser = DateParserForTest()
//        var dateToCheck: Date?
//        var correctDate: Date?
//        do {
//            correctDate = try dateParser.getLastUpdateDateFromSource(source: "")
//            XCTAssertNotNil(correctDate)
//        }
//        catch {
//            XCTFail("Буду падаю вчера")
//        }
//        
//        let dateNetworkManager = DateNetworkManagerWithParsing(urlSource: urlSource, dateParser: dateParser)
//        dateNetworkManager.getLastUpdateDate(group: AcademicGroupDTO(fullNumber: 141), departmentCode: "knt", resultQueue: .main) { result in
//            switch result {
//            case .success(let date):
//                dateToCheck = date
//            case .failure(let error):
//                XCTFail("Ошибка в менеджере: \(error.localizedDescription)")
//            }
//            didReceiveResponse.fulfill()
//        }
//        
//        wait(for: [didReceiveResponse], timeout: 5)
//        
//        XCTAssertNotNil(dateToCheck)
//        XCTAssertEqual(dateToCheck!.getDayAndMonthString(), correctDate!.getDayAndMonthString())
//    }
//    
    func testGroupsNetworkManagerWithParsingGetsUpdateDate() {
        let didReceiveResponse = expectation(description: #function)
        
        let groupsParser = GroupsParserForTest()
        var groupsToCheck: [AcademicGroupDTO]?
        var correctGroups: [AcademicGroupDTO]?
        do {
            correctGroups = try groupsParser.getGroupsByYearAndAcademicProgramFromSource(source: "", year: 1, departmentCode: "knt", program: .BachelorAndSpeciality)
            XCTAssertNotNil(correctGroups)
        }
        catch {
            XCTFail("Падает не тот кто падал, а тот кто вставал")
        }
        
        let groupsNetworkManager = GroupsNetworkManagerWithParsing(urlSource: urlSource, groupsParser: groupsParser, scraper: DynamicScraper())
        groupsNetworkManager.getGroupsByYearAndAcademicProgram(year: 1, program: .BachelorAndSpeciality, department: Department(code: "knt")) { result in
            switch result {
            case .success(let groups):
                groupsToCheck = groups
            case .failure(let error):
                XCTFail("Ошибка в менеджере: \(error.localizedDescription)")
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 5)
        
        XCTAssertNotNil(groupsToCheck)
        XCTAssertEqual(groupsToCheck, correctGroups)
    }
    
    func testSessionEventsNetworkManagerWithParsingGetsSessionEvents() {
        let didReceiveResponse = expectation(description: #function)
        
        let sessionEventsParser = SessionEventsParserForTest()
        var sessionEventsToCheck: GroupSessionEventsDTO?
        var correctSessionEvents: GroupSessionEventsDTO?
        do {
            correctSessionEvents = try sessionEventsParser.getGroupSessionEventsFromSource(source: "", groupNumber: "141", departmentCode: "knt")
            XCTAssertNotNil(correctSessionEvents)
        }
        catch {
            XCTFail("Нет падения печальнее на свете, чем с горы в Тибете (чего блять)")
        }
        
        let sessionEventsNetworkManager = SessionEventsNetworkManagerWithParsing(urlSource: urlSource, sessionEventsParser: sessionEventsParser, scraper: DynamicScraper())
        sessionEventsNetworkManager.getGroupSessionEvents(group: AcademicGroupDTO(fullNumber: "141", departmentCode: "knt")) { result in
            switch result {
            case .success(let sessionEvents):
                sessionEventsToCheck = sessionEvents
            case .failure(let error):
                XCTFail("Ошибка в менеджере: \(error.localizedDescription)")
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 5)
        
        XCTAssertNotNil(sessionEventsToCheck)
        XCTAssertEqual(sessionEventsToCheck!.sessionEvents, correctSessionEvents!.sessionEvents)
    }
    
    func testTeacherNetworkManagerWithParsingGetsSessionEvents() {
        let didReceiveResponse = expectation(description: #function)
        
        let sessionEventsParser = SessionEventsParserForTest()
        var sessionEventsToCheck: GroupSessionEventsDTO?
        var correctSessionEvents: GroupSessionEventsDTO?
        do {
            correctSessionEvents = try sessionEventsParser.getGroupSessionEventsFromSource(source: "", groupNumber: "141", departmentCode: "knt")
            XCTAssertNotNil(correctSessionEvents)
        }
        catch {
            XCTFail("Упал - вставай, встал - упай")
        }
        
        let sessionEventsNetworkManager = SessionEventsNetworkManagerWithParsing(urlSource: urlSource, sessionEventsParser: sessionEventsParser, scraper: DynamicScraper())
        sessionEventsNetworkManager.getGroupSessionEvents(group: AcademicGroupDTO(fullNumber: "141", departmentCode: "knt")) { result in
            switch result {
            case .success(let sessionEvents):
                sessionEventsToCheck = sessionEvents
            case .failure(let error):
                XCTFail("Ошибка в менеджере: \(error.localizedDescription)")
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 5)
        
        XCTAssertNotNil(sessionEventsToCheck)
        XCTAssertEqual(sessionEventsToCheck!.sessionEvents, correctSessionEvents!.sessionEvents)
    }
}
