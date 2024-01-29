//
//  SGU_ScheduleIntegrationTests.swift
//  SGU_ScheduleTests
//
//  Created by Артемий on 27.09.2023.
//

import XCTest
import SwiftUI
@testable import SGU_Schedule

final class SGU_ScheduleIntegrationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testNetworkManagerGetsCorrectUpdateDate_shouldBeTrue() throws { // в интеграционных потому что проверяет и менеджер, и декодер
        let didReceiveResponse = expectation(description: #function)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "dd'.'MM'.'yyyy'"
        let correctDate = dateFormatter.date(from: "15.01.2024")! //ToDo: может быть заmockать нормально
        
        var dateToCheck = Date.distantFuture
        
        let networkManager: DateNetworkManager
        networkManager = DateNetworkManagerWithParsing(urlSource: URLSourceSGU(), dateParser: DateHTMLParserSGU())
        networkManager.getLastUpdateDate(group: GroupDTO(fullNumber: 141), resultQueue: .main) { result in
            switch result {
            case .success(let date):
                dateToCheck = date
            case .failure(let error):
                print(error.localizedDescription)
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 5)
        
        XCTAssertEqual(dateToCheck, correctDate)
    }
    
    func testNetworkManagerGetCorrectGroupsByYearAndAcademicProgram_shouldBeTrue() throws {
        let didReceiveResponse = expectation(description: #function)
        
        let networkManager: GroupNetworkManager
        
        networkManager = GroupNetworkManagerWithParsing(urlSource: URLSourceSGU(), groupsParser: GroupsHTMLParserSGU())
        networkManager.getGroupsByYearAndAcademicProgram(year: 3, program: .Postgraduade, resultQueue: .main) { result in
            switch result {
            case .success(let groups):
                print(groups)
            case .failure(let failure):
                print(failure)
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 5)
    }
}