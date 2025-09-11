import Vapor
import SguParser


func routes(_ app: Application) throws {
    let scheduleController = ScheduleController()

    let api = app.grouped("api")

    api.post("schedule", use: scheduleController.parseLessons)

    app.get { req async in
        "Server is running!"
    }

    app.get("hello") { req async -> String in
        "Hello, world!"
    }
}

