//
//  ScheduleViewModelWithParsingSGU.swift
//  SGU_Schedule
//
//  Created by Артемий on 07.10.2023.
//

import Foundation

final class ScheduleViewModelWithParsingSGU: ScheduleViewModel {
    private let lessonsNetworkManager: LessonNetworkManager
    private let sessionEventsNetworkManager: SessionEventsNetworkManager
    private let dateNetworkManager: DateNetworkManager
    private let schedulePersistenceManager: GroupSchedulePersistenceManager
    
    @Published var schedule: GroupScheduleDTO?
    @Published var currentEvent: (any ScheduleEventDTO)? = nil
    @Published var groupSessionEvents: GroupSessionEventsDTO?
    
    @Published var nextLesson1: LessonDTO? = nil
    @Published var nextLesson2: LessonDTO? = nil
    
    @Published var updateDate = Date.distantFuture
    
    @Published var isLoadingLessons = true
    @Published var isLoadingUpdateDate = true
    @Published var isLoadingSessionEvents = true
    
    @Published var isShowingError = false
    @Published var activeError: LocalizedError?
    
    var favoriteGroupNumber: Int? {
        get {
            let number = UserDefaults.standard.integer(forKey: ViewModelsKeys.favoriteGroupNumberKey.rawValue)
            return number != 0 ? number : nil
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: ViewModelsKeys.favoriteGroupNumberKey.rawValue)
            do {
                if schedule != nil {
                    try saveNewScheduleWithClearingPreviousVersion(schedule: schedule!)
                }
            }
            catch(let error) {
                self.isShowingError = true
                
                if let coreDataError = error as? CoreDataError {
                    self.activeError = coreDataError
                } else {
                    self.activeError = CoreDataError.unexpectedError
                }
            }
        }
    }
    
    init(lessonsNetworkManager: LessonNetworkManager, 
         sessionEventsNetworkManager: SessionEventsNetworkManager,
         dateNetworkManager: DateNetworkManager, 
         schedulePersistenceManager: GroupSchedulePersistenceManager) {
        
        self.lessonsNetworkManager = lessonsNetworkManager
        self.sessionEventsNetworkManager = sessionEventsNetworkManager
        self.dateNetworkManager = dateNetworkManager
        self.schedulePersistenceManager = schedulePersistenceManager
    }
    
    /// If groupNumber isn't favorite and isOnline true - fetches lessons throught network manager
    /// If groupNumber is favorite and schedule from CoreData it is not same as from networkManager - rewrites it. Otherwise just fetches lessons from CoreData.
    public func fetchUpdateDateAndSchedule(groupNumber: Int, isOnline: Bool) {
        resetData()
        
        let dispatchGroup = DispatchGroup()
        
        if isOnline {
            dispatchGroup.enter()
            dateNetworkManager.getLastUpdateDate(group: GroupDTO(fullNumber: groupNumber), resultQueue: .main) { result in
                switch result {
                case .success(let date):
                    self.updateDate = date
                case .failure(let error):
                    self.showNetworkError(error: error)
                }
                self.isLoadingUpdateDate = false
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            do {
                let schedule = try self.schedulePersistenceManager.fetchAllItemsDTO().first
                
                if self.favoriteGroupNumber == groupNumber {
                    if isOnline {
                        
                        // Если есть сохраненное в память раннее, сначала ставится оно
                        if self.updateDate.getDayAndMonthString() != Date().getDayAndMonthString() && schedule != nil {
                            self.schedule = schedule
                            self.setCurrentAndTwoNextLessons()
                            self.isLoadingLessons = false
                        }
                        
                        // Получение расписания через networkManager и сравнение его с сохраненным (если оно есть)
                        self.lessonsNetworkManager.getGroupScheduleForCurrentWeek(group: GroupDTO(fullNumber: groupNumber), resultQueue: DispatchQueue.main) { result in
                            switch result {
                            case .success(let networkSchedule):
                                do {
                                    if schedule == nil || networkSchedule.lessons != schedule!.lessons {
                                        self.schedule = networkSchedule
                                        try self.saveNewScheduleWithClearingPreviousVersion(schedule: networkSchedule)
                                        self.setCurrentAndTwoNextLessons()
                                    } else {
                                        self.schedule = schedule
                                    }
                                    
                                    self.isLoadingLessons = false
                                }
                                catch (let error) {
                                    self.showCoreDataError(error: error)
                                }
                                
                            case .failure(let error):
                                self.showNetworkError(error: error)
                            }
                        }
                        
                    } else {
                        if schedule != nil {
                            self.schedule = schedule
                            self.setCurrentAndTwoNextLessons()
                        }
                        self.isLoadingLessons = false
                    }
                    
                } else {
                    self.lessonsNetworkManager.getGroupScheduleForCurrentWeek(group: GroupDTO(fullNumber: groupNumber), resultQueue: DispatchQueue.main) { result in
                        switch result {
                        case .success(let schedule):
                            self.schedule = schedule
                            self.setCurrentAndTwoNextLessons()
                            
                        case .failure(let error):
                            self.showNetworkError(error: error)
                        }
                        
                        self.isLoadingLessons = false
                    }
                }
            }
            catch (let error) {
                self.showCoreDataError(error: error)
            }
        }
    }
    
    public func fetchSessionEvents(groupNumber: Int, isOnline: Bool) {
        if isOnline {
            sessionEventsNetworkManager.getGroupSessionEvents(group: GroupDTO(fullNumber: groupNumber), resultQueue: .main) { result in
                switch result {
                case .success(let date):
                    self.groupSessionEvents = date
                case .failure(let error):
                    self.showNetworkError(error: error)
                }
                self.isLoadingSessionEvents = false
            }
        }
    }
    
    public func resetData() {
        currentEvent = nil
        nextLesson1 = nil
        nextLesson2 = nil
        
        isLoadingLessons = true
        isLoadingUpdateDate = true
        isLoadingSessionEvents = true
    }
    
    private func showNetworkError(error: Error) {
        self.isShowingError = true
        
        if let networkError = error as? NetworkError {
            self.activeError = networkError
        } else {
            self.activeError = NetworkError.unexpectedError
        }
    }
    
    private func showCoreDataError(error: Error) {
        self.isShowingError = true
        
        if let coreDataError = error as? CoreDataError {
            self.activeError = coreDataError
        } else {
            self.activeError = CoreDataError.unexpectedError
        }
    }
    
    private func fetchUpdateDate(groupNumber: Int) {
        dateNetworkManager.getLastUpdateDate(group: GroupDTO(fullNumber: groupNumber), resultQueue: .main) { result in
            switch result {
            case .success(let date):
                self.updateDate = date
            case .failure(let error):
                self.showNetworkError(error: error)
            }
            self.isLoadingUpdateDate = false
        }
    }
    
    /// May throw failedToClear or failedToSave errors
    private func saveNewScheduleWithClearingPreviousVersion(schedule: GroupScheduleDTO) throws {
        try self.schedulePersistenceManager.clearAllItems()
        try self.schedulePersistenceManager.saveItem(item: schedule)
    }
    
    private func setCurrentAndTwoNextLessons() {
        currentEvent = nil
        nextLesson1 = nil
        nextLesson2 = nil
        
        if schedule == nil {
            return
        }
        
        let currentDayNumber = Date.currentWeekDayWithEveningBeingNextDay.number
        let currentTime = Date.currentHoursAndMinutes
        
        if currentDayNumber == 7 {
            return
        }
        
        let todayLessons = schedule!.lessons.filter { $0.weekDay.number == currentDayNumber && Date.checkIfWeekTypeIsAllOrCurrent($0.weekType) }
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
