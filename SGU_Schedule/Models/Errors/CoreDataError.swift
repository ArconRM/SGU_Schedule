//
//  CoreDataError.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.10.2023.
//

import Foundation

enum CoreDataError: Error {
    case failedToSave
    case failedToFetch
    case failedToClear
}
