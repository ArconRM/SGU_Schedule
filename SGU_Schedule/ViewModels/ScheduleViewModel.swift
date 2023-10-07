//
//  ScheduleViewModel.swift
//  SGU_Schedule
//
//  Created by Артемий on 07.10.2023.
//

import Foundation

final class ScheduleViewModelWithParsing: ObservableObject {
    @Published var lessonsByDays = [[[Lesson]]]()
    @Published var updateDate = Date()
    
    @Published var isLoadingLessons = true
    @Published var isLoadingUpdateDate = true
    
    private var networkManager: NetworkManagerWithParsing
    private var htmlParser = LessonHTMLParser()
    
    init(lessonsByDays: [[[Lesson]]] = [[[Lesson]]](), networkManager: NetworkManagerWithParsing) {
        self.lessonsByDays = lessonsByDays
        self.networkManager = networkManager
    }
    
    public func fetchUpdateDate(groupNumber: Int) {
        networkManager.getLastUpdateDate(group: Group(FullNumber: groupNumber)) { result in
            switch result {
            case .success(let date):
                self.updateDate = date
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.isLoadingUpdateDate = false
        }
    }
    
    public func fetchAllLessons(groupNumber: Int) {
        networkManager.getScheduleForCurrentWeek(group: Group(FullNumber: groupNumber), isNumerator: true) { result in
            switch result {
            case .success(let lessons):
                self.lessonsByDays = lessons
            case .failure(let error):
                print(error.localizedDescription)
            }
            self.isLoadingLessons = false
        }
    }
}
