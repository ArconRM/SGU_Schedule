//
//  ScheduleViewModelsAssembly.swift
//  SGU_Schedule
//
//  Created by Артемий on 04.02.2024.
//

import Foundation

//аллегория на https://habr.com/ru/articles/768850/ 
public protocol ScheduleViewModelsAssembly {
    associatedtype ViewModel where ViewModel: ScheduleViewModel
    
    func build() -> ViewModel
}
