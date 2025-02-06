//
//  NetworkManagerFactory.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 06.02.2025.
//

import Foundation

protocol NetworkManagerFactory {

    func makeLessonsNetworkManager() -> LessonNetworkManager
    func makeGroupsNetworkManager() -> GroupsNetworkManager
    func makeSessionEventsNetworkManager() -> SessionEventsNetworkManager
    func makeTeacherNetworkManager() -> TeacherNetworkManager
}
