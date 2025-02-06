//
//  NetworkTests.swift
//  SGU_ScheduleTests
//
//  Created by Artemiy MIROTVORTSEV on 06.02.2025.
//

import XCTest
@testable import SGU_Schedule

final class NetworkTests: XCTestCase {
    var testDepartment: Department!
    var testGroups: [AcademicGroupDTO]!
    var testTeacherEndpoint: String!
    
    var urlSource: URLSourceSGU!
    
    var lessonsNetworkManager: LessonNetworkManagerWithParsing!
    var groupsNetworkManager: GroupsNetworkManagerWithParsing!
    var sessionEventsNetworkManager: SessionEventsNetworkManagerWithParsing!
    var teacherNetworkManager: TeacherNetworkManagerWithParsing!
    
    override func setUp() {
        super.setUp()
        
        testDepartment = Department(code: "knt")
        testGroups = [AcademicGroupDTO(fullNumber: "241", departmentCode: testDepartment.code)]
        testTeacherEndpoint = "schedule/teacher/3920"
        
        urlSource = URLSourceSGU()
        
        let factory = NetworkManagerWithParsingSGUFactory()
        
        lessonsNetworkManager = factory.makeLessonsNetworkManager() as? LessonNetworkManagerWithParsing
        groupsNetworkManager = factory.makeGroupsNetworkManager() as? GroupsNetworkManagerWithParsing
        sessionEventsNetworkManager = factory.makeSessionEventsNetworkManager() as? SessionEventsNetworkManagerWithParsing
        teacherNetworkManager = factory.makeTeacherNetworkManager() as? TeacherNetworkManagerWithParsing
    }
    
    func testFetchGroupSchedule() throws {
        let didReceiveResponse = expectation(description: #function)
        
        lessonsNetworkManager.getGroupScheduleForCurrentWeek(group: testGroups[0]) { result in
            switch result {
            case .success(let schedule):
                XCTAssertNotNil(schedule)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 10)
    }
    
    func testLessonsNetworkManagerGetsTeacherSchedule() {
        let didReceiveResponse = expectation(description: #function)
        
        lessonsNetworkManager.getTeacherScheduleForCurrentWeek(teacherEndpoint: testTeacherEndpoint, resultQueue: .main) { result in
            switch result {
            case .success(let schedule):
                XCTAssertNotNil(schedule)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 10)
    }
    
    func testGroupsNetworkManagerGetsGroups() {
        let didReceiveResponse = expectation(description: #function)
        
        groupsNetworkManager.getGroupsByYearAndAcademicProgram(year: 2020, program: AcademicProgram.masters, department: testDepartment) { result in
            switch result {
            case .success(let groups):
                XCTAssertNotNil(groups)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 10)
    }
    
    func testSessionEventsNetworkManagerGetsGroupSessionEvents() {
        let didReceiveResponse = expectation(description: #function)
        
        sessionEventsNetworkManager.getGroupSessionEvents(group: testGroups[0]) { result in
            switch result {
            case .success(let events):
                XCTAssertNotNil(events)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 10)
    }
    
    func testSessionEventsNetworkManagerGetsTeacherSessionEvents() {
        let didReceiveResponse = expectation(description: #function)
        
        sessionEventsNetworkManager.getTeacherSessionEvents(teacherEndpoint: testTeacherEndpoint) { result in
            switch result {
                case .success(let events):
                XCTAssertNotNil(events)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 10)
    }
    
    func testTeacherNetworkManagerGetsTeacher() {
        let didReceiveResponse = expectation(description: #function)
        
        teacherNetworkManager.getTeacher(teacherEndpoint: testTeacherEndpoint) { result in
            switch result {
            case .success(let teacher):
                XCTAssertNotNil(teacher)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 10)
    }
    
    func testTeacherNetworkManagerGetsAllTeacherSearchResults() {
        let didReceiveResponse = expectation(description: #function)
        
        teacherNetworkManager.getAllTeachers() { result in
            switch result {
                case .success(let teachers):
                XCTAssertNotNil(teachers)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 10)
    }
}
