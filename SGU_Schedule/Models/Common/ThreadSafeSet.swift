//
//  ThreadSafeSet.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 06.01.2025.
//

import Foundation

class ThreadSafeSet<T: Hashable> {
    private var set: Set<T> = []
    private let queue = DispatchQueue(label: "ThreadSafeSetQueue", attributes: .concurrent)

    var count: Int {
        return queue.sync {
            set.count
        }
    }

    func insert(_ element: T) {
        queue.async(flags: .barrier) {
            self.set.insert(element)
        }
    }

    func getAllElements() -> Set<T> {
        return queue.sync {
            return set
        }
    }
}
