//
//  ScheduleController.swift
//  SguParsingService
//
//  Created by Artemiy MIROTVORTSEV on 11.09.2025.
//

import Vapor
import SguParser

final class ScheduleController {

    func parseLessons(req: Request) async throws -> [LessonDTO] {
        let lessonRequest = try req.content.decode(LessonRequest.self)
        
        let url = URI(string: lessonRequest.url)

        let response: ClientResponse
        do {
            response = try await req.client.get(url)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to fetch HTML from the URL: \(url)")
        }

        guard var body = response.body,
              let html = body.readString(length: body.readableBytes) else {
            throw Abort(.internalServerError, reason: "Response body was empty or could not be read.")
        }

        let parser = LessonHTMLParserSGU()
        
        do {
            let lessons = try parser.getScheduleFromSource(source: html)
            return lessons
        } catch {
            throw Abort(.internalServerError, reason: "Failed to parse the HTML schedule. Error: \(error)")
        }
    }
}
