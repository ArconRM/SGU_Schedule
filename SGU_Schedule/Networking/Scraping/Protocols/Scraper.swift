//
//  Scraper.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 26.08.2024.
//

import Foundation

public protocol Scraper {
    func scrapeUrl(_ url: URL, completionHandler: @escaping (String?) -> Void)
}
