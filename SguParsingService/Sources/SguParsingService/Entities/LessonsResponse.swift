//
//  LessonsResponse.swift
//  SguParsingService
//
//  Created by Artemiy MIROTVORTSEV on 11.09.2025.
//

@preconcurrency import SguParser
import Vapor

struct LessonsResponse: Content {
    let lessons: [LessonDTO]
}

extension LessonDTO: Content {
    
}
