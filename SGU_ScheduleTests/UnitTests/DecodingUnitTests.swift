//
//  DecodingUnitTests.swift
//  SGU_ScheduleTests
//
//  Created by Артемий on 05.02.2024.
//

import XCTest
import SwiftUI
@testable import SGU_Schedule
import Kanna
import WebKit

final class DecodingUnitTests: XCTestCase {
    
    let testGroupNumbers = [241, 141, 341, 441, 173, 273, 192, 193]
    let departmentCode = "knt"
    //    let urlSource = URLSourceSGU_old()
    let urlSource = URLSourceSGU()
    let lessonParser = LessonHTMLParserSGU()
    let groupsParser = GroupsHTMLParserSGU()
    let sessionEventsParser = SessionEventsHTMLParserSGU()
    let teacherParser = TeacherHTMLParserSGU_old()
    
    override func setUpWithError() throws {
        super.setUp()
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
//    func testLessonParserGetsSchedule() {
//        for testGroupNumber in [241] {
//            var result: GroupScheduleDTO?
//            
//            do {
//                html = try String(contentsOf: urlSource.getGroupScheduleURL(departmentCode: "knt", groupNumber: testGroupNumber), encoding: .utf8) //синхронно потому что щас похуй
//                //                html = try String(contentsOf: URL(string:"https://sgu.ru/schedule/teacher/475")!, encoding: .utf8) //синхронно потому что щас похуй
//            }
//            catch {
//                XCTFail("Не смог соскрябать html")
//            }
//            
//            XCTAssertNotNil(html)
//            
//            do {
//                result = try lessonParser.getGroupScheduleFromSource(source: html!, groupNumber: testGroupNumber)
//            }
//            catch {
//                XCTFail("Ошибка в парсере")
//            }
//            
//            XCTAssertNotNil(result)
//            print(result!)
//        }
//    }
    
//    func testDateParserGetsUpdateDate() {
//        for testGroupNumber in testGroupNumbers {
//            var html: String?
//            var result: Date?
//            
//            do {
//                html = try String(contentsOf: urlSource.getGroupScheduleURL(departmentCode: departmentCode, groupNumber: testGroupNumber), encoding: .utf8)
//            }
//            catch {
//                XCTFail("Не смог соскрябать html")
//            }
//            
//            XCTAssertNotNil(html)
//            
//            do {
//                result = try dateParser.getLastUpdateDateFromSource(source: html!)
//            }
//            catch {
//                XCTFail("Ошибка в парсере")
//            }
//            
//            XCTAssertNotNil(result)
//            print(result!)
//        }
//    }
    
    func testGroupParserGetsGroups() {
        var html: String?
        var result: [AcademicGroupDTO]?
        
        do {
            html = try String(contentsOf: urlSource.getBaseScheduleURL(departmentCode: departmentCode), encoding: .utf8)
        }
        catch {
            XCTFail("Не смог соскрябать html")
        }
        
        XCTAssertNotNil(html)
        
        for academicProgram in AcademicProgram.allCases {
            for year in 1...6 {
                do {
                    result = try groupsParser.getGroupsByYearAndAcademicProgramFromSource(source: html!, year: year, departmentCode: departmentCode, program: academicProgram)
                }
                catch {
                    XCTFail("Ошибка в парсере")
                }
                
                XCTAssertNotNil(result)
                print(result!)
            }
        }
    }
    
//    func testSessionEventsParserGetsSessionEvents() {
//        for testGroupNumber in testGroupNumbers {
//            var html: String?
//            var result: GroupSessionEventsDTO?
//            
//            do {
//                html = try String(contentsOf: urlSource.getGroupSessionEventsURL(departmentCode: departmentCode, groupNumber: testGroupNumber), encoding: .utf8)
//            }
//            catch {
//                XCTFail("Не смог соскрябать html")
//            }
//            
//            XCTAssertNotNil(html)
//            
//            do {
//                result = try sessionEventsParser.getGroupSessionEventsFromSource(source: html!, groupNumber: testGroupNumber)
//            }
//            catch {
//                XCTFail("Ошибка в парсере")
//            }
//            
//            XCTAssertNotNil(result)
//            print(result!)
//        }
//    }
    
    func testTeacherParserGetsTeacher() {
        var html: String?
        var result: Teacher?
        
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
    
    
    func testHehehe() {
        do {
            let html = try String(contentsOf: URL(string:"https://www.old.sgu.ru/schedule")!, encoding: .utf8)
            let doc = try HTML(html: html, encoding: .utf8)
            for i in 1...25 {
//                print("case ." + doc.xpath("//div[@class='panes_item panes_item__type_group']/ul[1]/li[\(i)]/a/@href").first!.text!.split(separator: "/")[1] + ":")
//                print("return \"" + doc.xpath("//div[@class='panes_item panes_item__type_group']/ul[1]/li[\(i)]/a").first!.text! + "\"")
                
                print("case ." + doc.xpath("//div[@class='panes_item panes_item__type_group']/ul[1]/li[\(i)]/a/@href").first!.text!.split(separator: "/")[1] + ":")
                print("return Department(fullName: \"" + doc.xpath("//div[@class='panes_item panes_item__type_group']/ul[1]/li[\(i)]/a").first!.text! + "\", code: \"" + doc.xpath("//div[@class='panes_item panes_item__type_group']/ul[1]/li[\(i)]/a/@href").first!.text!.split(separator: "/")[1] + "\")")
            }
        }
        catch {
            
        }
    }
    
}
