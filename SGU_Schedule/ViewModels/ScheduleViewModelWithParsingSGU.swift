//
//  ScheduleViewModelWithParsingSGU.swift
//  SGU_Schedule
//
//  Created by Артемий on 07.10.2023.
//

import Foundation

final class ScheduleViewModelWithParsingSGU: ScheduleViewModel {
    @Published var lessonsByDays = [[[Lesson]]]()
    @Published var currentLesson: Lesson? = nil
    @Published var twoNextLessons: [Lesson?] = [nil, nil]
    
    @Published var updateDate = Date()
    
    @Published var isLoadingLessons = true
    @Published var isLoadingUpdateDate = true
    
    private var lessonsNetworkManager: LessonsNetworkManager
    private var dateNetworkManager: DateNetworkManager
    
    init() {
        self.lessonsNetworkManager = LessonsNetworkManagerWithParsing(urlSource: URLSourceSGU(),
                                                                      lessonParser: LessonHTMLParserSGU())
        self.dateNetworkManager = DateNetworkManagerWithParsing(urlSource: URLSourceSGU(),
                                                                dateParser: DateHTMLParserSGU())
    }
    
    public func fetchUpdateDate(groupNumber: Int) {
        dateNetworkManager.getLastUpdateDate(group: Group(fullNumber: groupNumber), resultQueue: .main) { result in
            switch result {
            case .success(let date):
                self.updateDate = date
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.isLoadingUpdateDate = false
        }
    }
    
    public func fetchLessonsAndSetCurrentAndTwoNextLessons(groupNumber: Int) {
        lessonsNetworkManager.getLessonsForCurrentWeek(group: Group(fullNumber: groupNumber), resultQueue: DispatchQueue.main) { result in
            switch result {
            case .success(let lessons):
                self.lessonsByDays = lessons
                
                self.setCurrentAndTwoNextLessons()
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.isLoadingLessons = false
        }
    }
    
    
    private func setCurrentAndTwoNextLessons() {
        let currentDayNumber = Date.getTodaysDay().number
//        let currentDayNumber = 1
        let currentDate = Date.getTodaysTime()
        let todayLessons = lessonsByDays[currentDayNumber - 1]
        
        for i in 0...todayLessons.count-1 {
            let lessons = todayLessons[i]
            
            if  lessons.count > 0 && checkIfTimeIsBetweenTwoTimes(dateStart: lessons[0].timeStart, dateMiddle: currentDate, dateEnd: lessons[0].timeEnd) {
                currentLesson = lessons[0]
                if todayLessons.count > i + 2 {
                    twoNextLessons[0] = todayLessons[i+1][0]
                    twoNextLessons[1] = todayLessons[i+2][0]
                } else if todayLessons.count == i + 2 {
                    twoNextLessons[0] = todayLessons.last?[0]
                }
                break
            }
        }
    }
    
    /// Returns true if dateMiddle is more than dateStart or equals it and if dateMiddle is less than dateEnd or equals it
    private func checkIfTimeIsBetweenTwoTimes(dateStart: Date, dateMiddle: Date, dateEnd: Date) -> Bool {
        return compareDatesByTime(date1: dateMiddle, date2: dateStart) && compareDatesByTime(date1: dateEnd, date2: dateMiddle)
    }
    
    /// Returns true if date1 is bigger than date2 or equals it.
    private func compareDatesByTime(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        var dateToCompare1 = Date.init(timeIntervalSinceReferenceDate: 0)
        var dateToCompare2 = Date.init(timeIntervalSinceReferenceDate: 0)
        
        let date1Components = calendar.dateComponents([.hour, .minute], from: date1)
        let date2Components = calendar.dateComponents([.hour, .minute], from: date2)

        dateToCompare1 = calendar.date(byAdding: date1Components, to: dateToCompare1) ?? Date.now
        dateToCompare2 = calendar.date(byAdding: date2Components, to: dateToCompare2) ?? Date.now
        
        return dateToCompare1 >= dateToCompare2
    }
}
