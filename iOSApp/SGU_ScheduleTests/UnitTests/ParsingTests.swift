//
//  ParsingTests.swift
//  SGU_ScheduleTests
//
//  Created by Artemiy MIROTVORTSEV on 04.02.2025.
//

import XCTest
@testable import SGU_Schedule

final class ParsingTests: XCTestCase {
    var testDepartmentCode: String!
    var testGroupNumbers: [String]!
    
    var dynamicScraper: DynamicScraper!
    
    var urlSource: URLSourceSGU!
    
    var lessonParser: LessonHTMLParserSGU!
    var groupsParser: GroupsHTMLParserSGU!
    var sessionEventsParser: SessionEventsHTMLParserSGU!
    var teacherParser: TeacherHTMLParserSGU!
    
    override func setUp() {
        super.setUp()
        
        testDepartmentCode = "knt"
        testGroupNumbers = ["241"]
        
        dynamicScraper = DynamicScraper()
        
        urlSource = URLSourceSGU()
        
        lessonParser = LessonHTMLParserSGU()
        groupsParser = GroupsHTMLParserSGU()
        sessionEventsParser = SessionEventsHTMLParserSGU()
        teacherParser = TeacherHTMLParserSGU()
    }
    
    func testLessonParserGetsSchedule() throws {
        let didReceiveResponse = expectation(description: #function)
        
        for testGroupNumber in testGroupNumbers{
            var html: String?
            var result: GroupScheduleDTO?
            
            dynamicScraper.scrapeUrl(urlSource.getGroupScheduleURL(departmentCode: testDepartmentCode, groupNumber: testGroupNumber)) { result in
                html = result
                didReceiveResponse.fulfill()
            }
            
            wait(for: [didReceiveResponse], timeout: 10)
            XCTAssertNotNil(html)
            
            do {
                result = try lessonParser.getGroupScheduleFromSource(source: html!, groupNumber: testGroupNumber, departmentCode: testDepartmentCode)
            } catch(let error) {
                XCTFail(error.localizedDescription)
            }
            
            XCTAssertNotNil(result)
            print(result!)
        }
    }
    
    func testGroupParserGetsGroups() throws {
        let didReceiveResponse = expectation(description: #function)
        
        var html: String?
        var result: [AcademicGroupDTO]?
        
        dynamicScraper.scrapeUrl(urlSource.getBaseScheduleURL(departmentCode: testDepartmentCode)) { result in
            html = result
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 10)
        XCTAssertNotNil(html)
        
        for academicProgram in AcademicProgram.allCases {
            for year in 1...6 {
                do {
                    result = try groupsParser.getGroupsByYearAndAcademicProgramFromSource(source: html!, year: year, departmentCode: testDepartmentCode, program: academicProgram)
                } catch(let error) {
                    XCTFail(error.localizedDescription)
                }
                
                XCTAssertNotNil(result)
                print(result!)
            }
        }
    }
    
    func testSessionEventsParserGetsEvents() throws {
        let didReceiveResponse = expectation(description: #function)
        
        var html: String?
        var result: GroupSessionEventsDTO?
        
        for testGroupNumber in testGroupNumbers {
            dynamicScraper.scrapeUrl(urlSource.getGroupScheduleURL(departmentCode: testDepartmentCode, groupNumber: testGroupNumber)) { result in
                html = result
                didReceiveResponse.fulfill()
            }
            
            wait(for: [didReceiveResponse], timeout: 10)
            XCTAssertNotNil(html)
            
            do {
                result = try sessionEventsParser.getGroupSessionEventsFromSource(source: html!, groupNumber: testGroupNumber, departmentCode: testDepartmentCode)
            } catch(let error) {
                XCTFail(error.localizedDescription)
            }
            
            XCTAssertNotNil(result)
            print(result!)
        }
    }
    
    func testTeacherParserGetsAllTeacherSearchResults() throws {
        let didReceiveResponse = expectation(description: #function)
        
        var html: String?
        var result: Set<TeacherSearchResult>?
        
        dynamicScraper.scrapeUrl(urlSource.getAllTeachersURL()) { result in
            html = result
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 10)
        XCTAssertNotNil(html)
        
        do {
            result = try teacherParser.getAllTeacherSearchResultsFromSource(source: html!)
        } catch(let error) {
            XCTFail(error.localizedDescription)
        }
        
        XCTAssertNotNil(result)
        print(result!)
    }
}
