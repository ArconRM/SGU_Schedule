//
//  TeacherNetworkManagerWithParsing.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 27.05.2024.
//

import Foundation

public class TeacherNetworkManagerWithParsing: TeacherNetworkManager {
    
    private var urlSource: URLSource
    private var teacherParser: TeacherHTMLParser
    
    init(urlSource: URLSource, teacherParser: TeacherHTMLParser) {
        self.urlSource = urlSource
        self.teacherParser = teacherParser
    }
    
    public func getTeacher(
        teacherEndpoint: String,
        resultQueue: DispatchQueue = .main,
        completionHandler: @escaping (Result<Teacher, any Error>) -> Void
    ) {
        let teacherUrl = urlSource.getBaseTeacherURL(teacherEndPoint: teacherEndpoint)
        
        URLSession.shared.dataTask(with: teacherUrl as URL) { data, _, error in
            guard error == nil else {
                resultQueue.async { completionHandler(.failure(error!)) }
                return
            }
            
            do {
                let html = try String(contentsOf: teacherUrl, encoding: .utf8)
                let teacher = try self.teacherParser.getTeacherFromSource(source: html)
                
                resultQueue.async {
                    completionHandler(.success(teacher))
                }
            }
            catch {
                resultQueue.async { completionHandler(.failure(NetworkError.htmlParserError)) }
            }
        }.resume()
    }
}
