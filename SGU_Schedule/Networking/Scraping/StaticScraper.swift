//
//  StaticScraper.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 26.08.2024.
//

import Foundation

class StaticScraper: Scraper {
    func scrapeUrl(_ url: URL, completionHandler: @escaping (String?) -> ()) throws {
        do {
            let html = try String(contentsOf: url, encoding: .utf8)
            completionHandler(html)
        }
        catch let error {
            throw NetworkError.scraperError
        }
    }
}
