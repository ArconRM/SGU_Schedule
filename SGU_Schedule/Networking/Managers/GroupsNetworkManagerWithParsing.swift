//
//  GroupsNetworkManagerWithParsing.swift
//  SGU_Schedule
//
//  Created by Артемий on 13.10.2023.
//

import Foundation

/// С новым сайтом нужен DynamicScraper
public class GroupsNetworkManagerWithParsing: GroupsNetworkManager {
    private var urlSource: URLSource
    private var groupsParser: GroupsHTMLParser
    private let scraper: Scraper
    
    init(urlSource: URLSource, groupsParser: GroupsHTMLParser, scraper: Scraper) {
        self.urlSource = urlSource
        self.groupsParser = groupsParser
        self.scraper = scraper
    }
    
    public func getGroupsByYearAndAcademicProgram(
        year: Int,
        program: AcademicProgram,
        departmentCode: String,
        resultQueue: DispatchQueue = .main,
        completionHandler: @escaping (Result<[GroupDTO], Error>) -> Void
    ) {
        let url = urlSource.getBaseScheduleURL(departmentCode: departmentCode)
        
        do {
            try self.scraper.scrapeUrl(url) { html in
                do {
                    let groups = try self.groupsParser.getGroupsByYearAndAcademicProgramFromSource(
                        source: html ?? "",
                        year: year,
                        departmentCode: departmentCode,
                        program: program
                    )
                    
                    resultQueue.async { completionHandler(.success(groups)) }
                }
                catch {
                    resultQueue.async { completionHandler(.failure(NetworkError.htmlParserError)) }
                }
            }
        }
        catch {
            resultQueue.async { completionHandler(.failure(NetworkError.scraperError)) }
        }
    }
    
}
