//
//  DateNetworkManagerWithParsing.swift
//  SGU_Schedule
//
//  Created by Артемий on 13.10.2023.
//

import Foundation

public class DateNetworkManagerWithParsing: DateNetworkManager {
    
    private var urlSource: URLSource
    private var dateParser: DateHTMLParser
    
    init(urlSource: URLSource, dateParser: DateHTMLParser) {
        self.urlSource = urlSource
        self.dateParser = dateParser
    }
    
    /// May return htmlParserError or any other
    public func getLastUpdateDate(
        group: GroupDTO,
        resultQueue: DispatchQueue = .main,
        completionHandler: @escaping (Result<Date, Error>) -> Void
    ) {
        let groupUrl = urlSource.getScheduleUrlWithGroupParameter(parameter: String(group.fullNumber))
        
        URLSession.shared.dataTask(with: groupUrl as URL) { data, _, error in
            guard error == nil else {
                resultQueue.async { completionHandler(.failure(error!)) }
                return
            }
            
            do {
                let html = try String(contentsOf: groupUrl, encoding: .utf8)
                let updateDate = try self.dateParser.getLastUpdateDateFromSource(source: html)
                
                resultQueue.async {
                    completionHandler(.success(updateDate))
                }
            }
            catch {
                resultQueue.async { completionHandler(.failure(NetworkError.htmlParserError)) }
            }
        }.resume()
    }
    
}
