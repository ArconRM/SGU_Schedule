//
//  GroupsHTMLParserSGU_old.swift
//  SGU_Schedule
//
//  Created by Артемий on 13.10.2023.
//

import Foundation
import Kanna

final class GroupsHTMLParserSGU_old: GroupsHTMLParser {
    func getGroupsByYearAndAcademicProgramFromSource (
        source html: String,
        year: Int,
        departmentCode: String,
        program: AcademicProgram
    ) throws -> [GroupDTO] {
        
        var result = [GroupDTO]()
        var groupTypeRange = [Int]()
        switch program {
        case .BachelorAndSpeciality:
            groupTypeRange = [1, 2]
        case .Masters:
            groupTypeRange = [3]
        case .Postgraduade:
            groupTypeRange = [4]
        }
        
        do {
            let doc = try HTML(html: html, encoding: .utf8)
            for groupTypeNumber in groupTypeRange {
                let xpathResult = String(doc.xpath("//fieldset[@class='do form_education form-wrapper']/div[@class='fieldset-wrapper']/fieldset[@class='group-type form-wrapper'][\(groupTypeNumber)]/div[@class='fieldset-wrapper']/fieldset[@class='course form-wrapper'][\(year)]/div[@class='fieldset-wrapper']").first?.text ?? "Error").split(separator: " ")
                
                if xpathResult.count < 2 { //сомнительное место, верно только если на всех остальных разделах все так же, как на книитовском
                    continue
                }
                
                for i in 0...xpathResult.count-1 where i % 2 == 0 {
                    guard Int(xpathResult[i]) != nil else {
                        throw NetworkError.htmlParserError
                    }
                    result.append(GroupDTO(fullNumber: Int(xpathResult[i])!))
                }
                
            }
        }
        catch {
            throw NetworkError.htmlParserError
        }
        return result
    }
}
