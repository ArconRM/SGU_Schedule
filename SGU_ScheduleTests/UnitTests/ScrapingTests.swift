//
//  ScrapingTests.swift
//  SGU_ScheduleTests
//
//  Created by Artemiy MIROTVORTSEV on 04.02.2025.
//

import XCTest
@testable import SGU_Schedule

final class ScrapingTests: XCTestCase {
    var staticScraper: StaticScraper!
    var dynamicScraper: DynamicScraper!
    var urlToTest: URL!
    
    override func setUpWithError() throws {
        staticScraper = StaticScraper()
        dynamicScraper = DynamicScraper()
        urlToTest = URL(string: "https://old.sgu.ru/schedule/knt/do/241")
    }
    
    func testStaticScraper() throws {
        staticScraper.scrapeUrl(urlToTest) { result in
            XCTAssertNotNil(result)
        }
    }
    
    func testDynamicScraper() throws {
        dynamicScraper.scrapeUrl(urlToTest) { result in
            XCTAssertNotNil(result)
        }
    }
}
