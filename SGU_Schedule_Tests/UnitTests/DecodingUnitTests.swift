//
//  DecodingUnitTests.swift
//  SGU_ScheduleTests
//
//  Created by Артемий on 05.02.2024.
//

import XCTest
import SwiftUI
@testable import SGU_Schedule

final class DecodingUnitTests: XCTestCase {
    
    let testGroupNumbers = [141, 241, 341, 441, 173, 273, 192, 193]
    let urlSource = URLSourceSGU_old()
    
    override func setUpWithError() throws {
        super.setUp()
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLessonParserGetsSchedule() {
        for testGroupNumber in testGroupNumbers {
            let lessonParser = LessonHTMLParserSGU()
            var html: String?
            var result: GroupScheduleDTO?
            
            do {
                html = try String(contentsOf: urlSource.getScheduleUrlWithGroupParameter(parameter: String(testGroupNumber)), encoding: .utf8) //синхронно потому что щас похуй
                html = try String(contentsOf: URL(string:"https://old.sgu.ru/schedule/teacher/475")!, encoding: .utf8) //синхронно потому что щас похуй
            }
            catch {
                XCTFail("Не смог соскрябать html")
            }
            
            XCTAssertNotNil(html)
            
            do {
                result = try lessonParser.getGroupScheduleFromSource(source: html!, groupNumber: testGroupNumber)
            }
            catch {
                XCTFail("Ошибка в парсере")
            }
            
            XCTAssertNotNil(result)
            print(result!)
        }
    }
    
    func testDateParserGetsUpdateDate() {
        for testGroupNumber in testGroupNumbers {
            let dateParser = DateHTMLParserSGU()
            var html: String?
            var result: Date?
            
            do {
                html = try String(contentsOf: urlSource.getScheduleUrlWithGroupParameter(parameter: String(testGroupNumber)), encoding: .utf8)
            }
            catch {
                XCTFail("Не смог соскрябать html")
            }
            
            XCTAssertNotNil(html)
            
            do {
                result = try dateParser.getLastUpdateDateFromSource(source: html!)
            }
            catch {
                XCTFail("Ошибка в парсере")
            }
            
            XCTAssertNotNil(result)
            print(result!)
        }
    }
    
    func testGroupParserGetsGroups() {
        let groupsParser = GroupsHTMLParserSGU()
        var html: String?
        var result: [GroupDTO]?
        
        do {
            html = try String(contentsOf: URL(string: urlSource.baseScheduleString)!, encoding: .utf8)
        }
        catch {
            XCTFail("Что-то не так с ссылкой")
        }
        
        XCTAssertNotNil(html)
        
        for academicProgram in AcademicProgram.allCases {
            for year in 1...6 {
                do {
                    result = try groupsParser.getGroupsByYearAndAcademicProgramFromSource(source: html!, year: year, program: academicProgram)
                }
                catch {
                    XCTFail("Ошибка в парсере")
                }
                
                XCTAssertNotNil(result)
                print(result!)
            }
        }
    }
    
    func testSessionEventsParserGetsSessionEvents() {
        for testGroupNumber in testGroupNumbers {
            let sessionEventsParser = SessionEventsHTMLParserSGU()
            var html: String?
            var result: GroupSessionEventsDTO?
            
            do {
                html = try String(contentsOf: urlSource.getScheduleUrlWithGroupParameter(parameter: String(testGroupNumber)), encoding: .utf8)
            }
            catch {
                XCTFail("Не смог соскрябать html")
            }
            
            XCTAssertNotNil(html)
            
            do {
                result = try sessionEventsParser.getGroupSessionEventsFromSource(source: html!, groupNumber: testGroupNumber)
            }
            catch {
                XCTFail("Ошибка в парсере")
            }
            
            XCTAssertNotNil(result)
            print(result!)
        }
    }
    
    func testTeacherParserGetsTeacher() {
        let teacherParser = TeacherHTMLParserSGU()
        var html: String?
        var result: TeacherDTO?
        
        do {
            html = try String(contentsOf: URL(string:"https://www.old.sgu.ru/person/osipcev-mihail-anatolevich")!, encoding: .utf8) //легенда
        }
        catch {
            XCTFail("Не смог соскрябать html")
        }
        
        XCTAssertNotNil(html)
        
        do {
            result = try teacherParser.getTeacherFromSource(source: html!)
        }
        catch {
            XCTFail("Ошибка в парсере")
        }
        
        XCTAssertNotNil(result)
        print(result!)
    }
    
}
