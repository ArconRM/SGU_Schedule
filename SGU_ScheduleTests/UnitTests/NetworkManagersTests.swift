//
//  NetworkManagersTests.swift
//  SGU_ScheduleTests
//
//  Created by Artemiy MIROTVORTSEV on 05.02.2025.
//

import XCTest
@testable import SGU_Schedule

final class NetworkManagersTests: XCTestCase {
    
    var urlSource: URLSourceSGU!
    
    var lessonsNetworkManager: LessonNetworkManagerWithParsing!
    var groupsNetworkManager: GroupsNetworkManagerWithParsing!
    var sessionEventsNetworkManager: SessionEventsNetworkManagerWithParsing!
    var teacherNetworkManager: TeacherNetworkManagerWithParsing!
    
    override func setUp() {
        super.setUp()
        
        urlSource = URLSourceSGU()
        
        let factory = NetworkManagerWithMockDataFactory()
        
        lessonsNetworkManager = factory.makeLessonsNetworkManager() as? LessonNetworkManagerWithParsing
        groupsNetworkManager = factory.makeGroupsNetworkManager() as? GroupsNetworkManagerWithParsing
        sessionEventsNetworkManager = factory.makeSessionEventsNetworkManager() as? SessionEventsNetworkManagerWithParsing
        teacherNetworkManager = factory.makeTeacherNetworkManager() as? TeacherNetworkManagerWithParsing
    }
    
    func testLessonsNetworkManagerGetsGroupSchedule() {
        let didReceiveResponse = expectation(description: #function)
        
        lessonsNetworkManager.getGroupScheduleForCurrentWeek(group: AcademicGroupDTO.mock) { result in
            switch result {
            case .success(let schedule):
                XCTAssertEqual(schedule, GroupScheduleDTO.mock)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 10)
    }
    
    func testLessonsNetworkManagerGetsTeacherSchedule() {
        let didReceiveResponse = expectation(description: #function)
        
        lessonsNetworkManager.getTeacherScheduleForCurrentWeek(teacherEndpoint: "", resultQueue: .main) { result in
            switch result {
            case .success(let schedule):
                XCTAssertEqual(schedule, LessonDTO.mocks)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 10)
    }
    
    func testGroupsNetworkManagerGetsGroups() {
        let didReceiveResponse = expectation(description: #function)
        
        groupsNetworkManager.getGroupsByYearAndAcademicProgram(year: 2020, program: AcademicProgram.masters, department: Department.mock) { result in
            switch result {
            case .success(let groups):
                XCTAssertEqual(groups, [AcademicGroupDTO.mock])
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 10)
    }
    
    func testSessionEventsNetworkManagerGetsGroupSessionEvents() {
        let didReceiveResponse = expectation(description: #function)
        
        sessionEventsNetworkManager.getGroupSessionEvents(group: AcademicGroupDTO.mock) { result in
            switch result {
            case .success(let events):
                XCTAssertEqual(events, GroupSessionEventsDTO.mock)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 10)
    }
    
    func testSessionEventsNetworkManagerGetsTeacherSessionEvents() {
        let didReceiveResponse = expectation(description: #function)
        
        sessionEventsNetworkManager.getTeacherSessionEvents(teacherEndpoint: "") { result in
            switch result {
                case .success(let events):
                XCTAssertEqual(events, SessionEventDTO.mocks)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 10)
    }
    
    func testTeacherNetworkManagerGetsTeacher() {
        let didReceiveResponse = expectation(description: #function)
        
        teacherNetworkManager.getTeacher(teacherEndpoint: "") { result in
            switch result {
            case .success(let teacher):
                XCTAssertEqual(teacher, Teacher.mock)
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
                XCTAssertEqual(teachers, Set(TeacherSearchResult.mocks))
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 10)
    }
}
