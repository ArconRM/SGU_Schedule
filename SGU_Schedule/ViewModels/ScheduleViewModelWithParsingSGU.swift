//
//  ScheduleViewModelWithParsingSGU.swift
//  SGU_Schedule
//
//  Created by Артемий on 07.10.2023.
//

import Foundation

final class ScheduleViewModelWithParsingSGU: ScheduleViewModel {
    @Published var lessons = [LessonDTO]()
    @Published var currentEvent: (any EventDTO)? = nil
    
    @Published var nextLesson1: LessonDTO? = nil
    @Published var nextLesson2: LessonDTO? = nil
    
    var favoriteGroupNumber: Int? {
        get {
            let number = UserDefaults.standard.integer(forKey: ViewModelsKeys.favoriteGroupNumberKey.rawValue)
            return number != 0 ? number : nil
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: ViewModelsKeys.favoriteGroupNumberKey.rawValue)
            do {
                try self.schedulePersistenceManager.clearAllItems()
            }
            catch(let error) {
                print(error.localizedDescription)
            }
        }
    }
    
    @Published var updateDate = Date.distantFuture
    
    @Published var isLoadingLessons = true
    @Published var isLoadingUpdateDate = true
    
    private var lessonsNetworkManager: LessonsNetworkManager
    private var dateNetworkManager: DateNetworkManager
    private var schedulePersistenceManager: GroupScheduleCoreDataManager
    
    init() {
        self.lessonsNetworkManager = LessonsNetworkManagerWithParsing(urlSource: URLSourceSGU(),
                                                                      lessonParser: LessonHTMLParserSGU())
        self.dateNetworkManager = DateNetworkManagerWithParsing(urlSource: URLSourceSGU(),
                                                                dateParser: DateHTMLParserSGU())
        self.schedulePersistenceManager = GroupScheduleCoreDataManager()
    }
    
    /// If groupNumber isn't favorite and isOnline true - fetches lessons throught network manager and caches it
    /// If groupNumber is favorite and todays date equals updateDate (or nothing was previously saved) - fetches lessons throught network manager and saves it to CoreData
    /// If groupNumber is favorite and schedule was previously saved - fetches lessons from CoreData
    /// In over cases it does nothing
    public func fetchUpdateDateAndLessons(groupNumber: Int, isOnline: Bool) {
        let dispatchGroup = DispatchGroup()
        
        if isOnline {
            dispatchGroup.enter()
            dateNetworkManager.getLastUpdateDate(group: GroupDTO(fullNumber: groupNumber), resultQueue: .main) { result in
                switch result {
                case .success(let date):
                    self.updateDate = date
                case .failure(let error):
                    print(error.localizedDescription)
                }
                dispatchGroup.leave()
                self.isLoadingUpdateDate = false
            }
        }
        dispatchGroup.notify(queue: .main) {
            do {
                let schedule = try self.schedulePersistenceManager.fetchAllItemsDTO().first
                
                if self.favoriteGroupNumber == groupNumber {
                    if isOnline {
                        if self.updateDate.getDayAndMonthString() == Date().getDayAndMonthString() || schedule == nil {
                            
                            self.lessonsNetworkManager.getGroupScheduleForCurrentWeek(group: GroupDTO(fullNumber: groupNumber), resultQueue: DispatchQueue.main) { result in
                                switch result {
                                case .success(let schedule):
                                    do {
                                        self.lessons = schedule.lessons
                                        try self.schedulePersistenceManager.clearAllItems()
                                        try self.schedulePersistenceManager.saveItem(item: schedule)
                                        
                                        self.setCurrentAndTwoNextLessons()
                                    }
                                    catch(let error) {
                                        print(error.localizedDescription)
                                    }
                                    
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                                
                                self.isLoadingLessons = false
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.lessons = schedule!.lessons
                                
                                self.isLoadingLessons = false
                                self.setCurrentAndTwoNextLessons()
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            if schedule != nil {
                                self.lessons = schedule!.lessons
                                self.setCurrentAndTwoNextLessons()
                            }
                            self.isLoadingLessons = false
                        }
                    }
                } else {
                    self.lessonsNetworkManager.getGroupScheduleForCurrentWeek(group: GroupDTO(fullNumber: groupNumber), resultQueue: DispatchQueue.main) { result in
                        switch result {
                        case .success(let schedule):
                            self.lessons = schedule.lessons
                            
                            self.setCurrentAndTwoNextLessons()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                        
                        self.isLoadingLessons = false
                    }
                }
            }
            catch(let error) {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchUpdateDate(groupNumber: Int) {
        dateNetworkManager.getLastUpdateDate(group: GroupDTO(fullNumber: groupNumber), resultQueue: .main) { result in
            switch result {
            case .success(let date):
                self.updateDate = date
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.isLoadingUpdateDate = false
        }
    }
    
    private func setCurrentAndTwoNextLessons() {
        currentEvent = nil
        nextLesson1 = nil
        nextLesson2 = nil
        
        let currentDayNumber = Date.currentWeekDay.number
        if currentDayNumber == 7 {
            return
        }
        
        let currentTime = Date.currentTime
        let todayLessons = lessons.filter { $0.weekDay.number == currentDayNumber && Date.checkIfWeekTypeIsAllOrCurrent($0.weekType) }
        if todayLessons.isEmpty {
            return
        }
        
        for lessonNumber in 1...8 {
            let todayLessonsByNumber = todayLessons.filter { $0.lessonNumber == lessonNumber }
            if todayLessonsByNumber.isEmpty {
                continue
            }
            
            if checkIfTimeIsBetweenTwoTimes(dateStart: todayLessonsByNumber[0].timeStart,
                                            dateMiddle: currentTime,
                                            dateEnd: todayLessonsByNumber[0].timeEnd) {
                var newCurrentLesson = todayLessonsByNumber[0]
                if todayLessonsByNumber.count > 1 { //значит есть подгруппы и общего кабинета нет
                    newCurrentLesson.cabinet = "По подгруппам"
                }
                currentEvent = newCurrentLesson
                setNextTwoLessons(lessons: todayLessons, from: lessonNumber)
                return
                
            } else if lessonNumber != 8 { // смотрим следующую пару, когда находим - выходим
                for nextLessonNumber in (lessonNumber + 1)...8 {
                    let todayLessonsByNumberNext = todayLessons.filter { $0.lessonNumber == nextLessonNumber }
                    if todayLessonsByNumberNext.isEmpty {
                        continue
                    }
                    
                    if checkIfTimeIsBetweenTwoTimes(dateStart: todayLessonsByNumber[0].timeEnd,
                                                    dateMiddle: currentTime,
                                                    dateEnd: todayLessonsByNumberNext[0].timeStart) {
                        currentEvent = TimeBreakDTO(timeStart: todayLessonsByNumber[0].timeEnd, timeEnd: todayLessonsByNumberNext[0].timeStart)
                        setNextTwoLessons(lessons: todayLessons, from: lessonNumber)
                    }
                    
                    if !todayLessonsByNumberNext.isEmpty {
                        break
                    }
                }
            }
        }
    }
    
    /// If possible, sets twoNextLessons to two nearest lessons from given array, which have greater lessonNumber than given one
    private func setNextTwoLessons(lessons: [LessonDTO], from number: Int) {
        for nextLessonNumber in (number + 1)...8 {
            let lessonsByNumber = lessons.filter { $0.lessonNumber == nextLessonNumber }
            if !lessonsByNumber.isEmpty {
                if nextLesson1 == nil {
                    var newNextLesson = lessonsByNumber[0]
                    if lessonsByNumber.count > 1 {
                        newNextLesson.cabinet = "По подгруппам"
                    }
                    nextLesson1 = newNextLesson
                } else if nextLesson2 == nil {
                    var newNextLesson = lessonsByNumber[0]
                    if lessonsByNumber.count > 1 {
                        newNextLesson.cabinet = "По подгруппам"
                    }
                    nextLesson2 = newNextLesson
                }
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
