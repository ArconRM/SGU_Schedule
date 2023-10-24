//
//  ScheduleViewModelWithParsingSGU.swift
//  SGU_Schedule
//
//  Created by Артемий on 07.10.2023.
//

import Foundation

final class ScheduleViewModelWithParsingSGU: ScheduleViewModel {
    @Published var lessonsByDays = [[[Lesson]]]()
    @Published var currentEvent: (any Event)? = nil
    /// Should always contain two objects
    @Published var nextTwoLessons: [Lesson?] = [nil, nil]
    
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
        let currentDayNumber = Date.currentWeekDay.number
        let currentWeekType = Date.currentWeekType
        let currentTime = Date.currentTime
        let todayLessons = lessonsByDays[currentDayNumber - 1]
        
        if todayLessons.count == 1 && checkIfTimeIsBetweenTwoTimes(dateStart: todayLessons[0][0].timeStart,
                                                                   dateMiddle: currentTime,
                                                                   dateEnd: todayLessons[0][0].timeEnd) {
            currentEvent = todayLessons[0][0]
            nextTwoLessons = [nil, nil]
            return
            
        } else if todayLessons.count > 1 {
            for i in 0...todayLessons.count-2 {
                let lessons1 = todayLessons[i].filter { Date.checkIfWeekTypeIsAllOrCurrent($0.weekType) } //следующая пара (возможно пустая)
                let lessons2 = todayLessons.suffix(from: i+1) //позаследующая, если пустая - значит дальше ничего с текущим типом недели нет
                    .filter({ lessons in
                        for lesson in lessons {
                            if Date.checkIfWeekTypeIsAllOrCurrent(lesson.weekType) {
                                return true
                            }
                        }
                        return false
                    })
                    .first { $0.count > 0 } ?? []
                
                if lessons1.count > 0 && checkIfTimeIsBetweenTwoTimes(dateStart: lessons1[0].timeStart,
                                                                      dateMiddle: currentTime,
                                                                      dateEnd: lessons1[0].timeEnd) {
                    var newCurrentLesson = lessons1[0]
                    if lessons1.count > 1 { //значит есть подгруппы и общего кабинета нет
                        newCurrentLesson.cabinet = ""
                    }
                    
                    currentEvent = newCurrentLesson
                    setNextTwoLessons(lessons: todayLessons, from: i)
                    return
                    
                } else if lessons1.count > 0 && lessons2.count > 0 && checkIfTimeIsBetweenTwoTimes(dateStart: lessons1[0].timeEnd,
                                                                                                   dateMiddle: currentTime,
                                                                                                   dateEnd: lessons2[0].timeStart) {
                    currentEvent = TimeBreak(timeStart: lessons1[0].timeEnd, timeEnd: lessons2[0].timeStart)
                    setNextTwoLessons(lessons: todayLessons, from: i)
                    return
                }
                
                // проверка последнего
                let lessons = todayLessons.last!.filter { Date.checkIfWeekTypeIsAllOrCurrent($0.weekType) }
                
                if lessons.count > 0 && checkIfTimeIsBetweenTwoTimes(dateStart: lessons[0].timeStart,
                                                                     dateMiddle: currentTime,
                                                                     dateEnd: lessons[0].timeEnd) {
                    var newCurrentLesson = lessons[0]
                    if lessons.count > 1 { //значит есть подгруппы и общего кабинета нет
                        newCurrentLesson.cabinet = ""
                    }
                    
                    currentEvent = newCurrentLesson
                    nextTwoLessons = [nil, nil]
                    return
                }
            }
        }
        
        currentEvent = nil
        nextTwoLessons = [nil, nil]
    }
    
    private func setNextTwoLessons(lessons: [[Lesson]], from index: Int) {
        let lessonsSlice = lessons[(index+1)...]
        
        if lessonsSlice.count == 1 {
            let nextLessons1 = lessonsSlice.first!.filter{ Date.checkIfWeekTypeIsAllOrCurrent($0.weekType) }
            
            if nextLessons1.count > 0 {
                var nextLesson1 = nextLessons1[0]
                if nextLessons1.count > 1 {
                    nextLesson1.cabinet = ""
                }
                nextTwoLessons = [nextLesson1, nil]
            }
            
        }
        if lessonsSlice.count > 1 {
            let nextLessons2 = lessonsSlice.dropFirst().first!.filter{ Date.checkIfWeekTypeIsAllOrCurrent($0.weekType) }
            
            if nextLessons2.count > 0 {
                var nextLesson2 = nextLessons2[0]
                if nextLessons2.count > 1 {
                    nextLesson2.cabinet = ""
                }
                nextTwoLessons[1] = nextLesson2
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
