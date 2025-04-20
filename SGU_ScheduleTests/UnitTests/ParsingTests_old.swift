//
//  ParsingTests_old.swift
//  SGU_ScheduleTests
//
//  Created by Artemiy MIROTVORTSEV on 04.02.2025.
//

import XCTest
@testable import SGU_Schedule

final class ParsingTests_old: XCTestCase {
    var testDepartmentCode: String!
    var testGroupNumbers: [String]!
    
    var staticScraper: StaticScraper!
    
    var urlSource: URLSourceSGU_old!
    
    var lessonParser: LessonHTMLParserSGU_old!
    var groupsParser: GroupsHTMLParserSGU_old!
    var sessionEventsParser: SessionEventsHTMLParserSGU_old!
    var teacherParser: TeacherHTMLParserSGU_old!
    
    override func setUp() {
        super.setUp()
        
        testDepartmentCode = "knt"
        testGroupNumbers = ["241"]
        
        staticScraper = StaticScraper()
        
        urlSource = URLSourceSGU_old()
        
        lessonParser = LessonHTMLParserSGU_old()
        groupsParser = GroupsHTMLParserSGU_old()
        sessionEventsParser = SessionEventsHTMLParserSGU_old()
        teacherParser = TeacherHTMLParserSGU_old()
    }
    
    func testLessonParserGetsSchedule() throws {
        let didReceiveResponse = expectation(description: #function)
        
        for testGroupNumber in testGroupNumbers{
            var html: String?
            var result: GroupScheduleDTO?
            
            staticScraper.scrapeUrl(urlSource.getGroupScheduleURL(departmentCode: testDepartmentCode, groupNumber: testGroupNumber)) { result in
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
        
        staticScraper.scrapeUrl(urlSource.getBaseScheduleURL(departmentCode: testDepartmentCode)) { result in
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
            staticScraper.scrapeUrl(urlSource.getGroupScheduleURL(departmentCode: testDepartmentCode, groupNumber: testGroupNumber)) { result in
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
    
    func testTeacherParserGetsTeacher() {
        let didReceiveResponse = expectation(description: #function)
        
        var html: String?
        var result: TeacherDTO?
        
        staticScraper.scrapeUrl(URL(string:"https://old.sgu.ru/person/ogneva-marina-valentinovna")!) { result in
            html = result
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 10)
        XCTAssertNotNil(html)
        
        do {
            result = try teacherParser.getTeacherFromSource(source: html!)
        } catch(let error) {
            XCTFail(error.localizedDescription)
        }
        
        XCTAssertNotNil(result)
        print(result!)
    }
}
