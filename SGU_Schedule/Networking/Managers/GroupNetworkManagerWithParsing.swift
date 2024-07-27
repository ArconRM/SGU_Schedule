//
//  GroupsNetworkManagerWithParsing.swift
//  SGU_Schedule
//
//  Created by Артемий on 13.10.2023.
//

import Foundation

public class GroupsNetworkManagerWithParsing: GroupsNetworkManager {
    
    private var urlSource: URLSource
    private var groupsParser: GroupsHTMLParser
    
    init(urlSource: URLSource, groupsParser: GroupsHTMLParser) {
        self.urlSource = urlSource
        self.groupsParser = groupsParser
    }

    public func getGroupsByYearAndAcademicProgram(
        year: Int,
        program: AcademicProgram,
        departmentCode: String,
        resultQueue: DispatchQueue = .main,
        completionHandler: @escaping (Result<[GroupDTO], Error>) -> Void
    ) {
        let url = urlSource.getBaseScheduleURL(departmentCode: departmentCode)
        
        URLSession.shared.dataTask(with: url as URL) { data, _, error in
            guard error == nil else {
                resultQueue.async { completionHandler(.failure(error!)) }
                return
            }
            
            do {
                let html = try String(contentsOf: url, encoding: .utf8)
                let groups = try self.groupsParser.getGroupsByYearAndAcademicProgramFromSource(source: html, year: year, program: program)
                
                resultQueue.async {
                    completionHandler(.success(groups))
                }
            }
            catch {
                resultQueue.async { completionHandler(.failure(NetworkError.htmlParserError)) }
            }
        }.resume()
    }
    
}
