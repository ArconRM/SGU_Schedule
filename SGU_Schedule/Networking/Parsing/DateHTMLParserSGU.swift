//
//  DateHTMLParserSGU.swift
//  SGU_Schedule
//
//  Created by Артемий on 13.10.2023.
//

import Foundation
import Kanna

final class DateHTMLParserSGU: DateHTMLParser {
    func getLastUpdateDateFromSource(source html: String) throws -> Date {
        do {
            let doc = try HTML(html: html, encoding: .utf8)
            let lastUpdateStr = String(doc.xpath("//div[@class='last-update']").first?.text?.dropFirst(22) ?? "01.01.2001")
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "dd'.'MM'.'yyyy'"
            let date = dateFormatter.date(from: lastUpdateStr)!
            
            return date
        }
        catch {
            throw NetworkError.htmlParserError
        }
    }
}
