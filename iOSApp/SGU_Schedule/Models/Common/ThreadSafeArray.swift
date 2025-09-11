//
//  ThreadSafeArray.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 06.01.2025.
//

import Foundation

// https://stackoverflow.com/questions/28191079/create-thread-safe-array-in-swift
class ThreadSafeArray<T> {
    private var array: [T] = []
    private let queue = DispatchQueue(label: "ThreadSafeArrayQueue", attributes: .concurrent)

    var count: Int {
        return queue.sync {
            array.count
        }
    }

    func append(_ element: T) {
        queue.async(flags: .barrier) {
            self.array.append(element)
        }
    }

    func getAllElements() -> [T] {
        return queue.sync {
            return array
        }
    }
}
