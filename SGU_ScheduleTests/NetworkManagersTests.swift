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
    var sessioneventsNetworkManager: SessionEventsNetworkManagerWithParsing!
    var teacherNetworkManager: TeacherNetworkManagerWithParsing!
    
    override func setUp() {
        super.setUp()
        
        lessonsNetworkManager = LessonNetworkManagerWithParsing(urlSource: urlSource, lessonParser: LessonParserMock(), scraper: )
    }
}
