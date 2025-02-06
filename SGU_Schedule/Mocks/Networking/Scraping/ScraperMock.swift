//
//  ScraperMock.swift
//  SGU_ScheduleTests
//
//  Created by Artemiy MIROTVORTSEV on 05.02.2025.
//

import Foundation

class ScraperMock: Scraper {
    func scrapeUrl(_ url: URL, completionHandler: @escaping (String?) -> Void) {
        completionHandler("")
    }
}
