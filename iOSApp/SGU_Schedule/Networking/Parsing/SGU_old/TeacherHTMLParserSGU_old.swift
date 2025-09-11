//
//  TeacherHTMLParserSGU_old.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 27.05.2024.
//

import Foundation
import Kanna

struct TeacherHTMLParserSGU_old: TeacherHTMLParser {
    func getTeacherFromSource(source html: String) throws -> TeacherDTO {
        do {
            let doc = try HTML(html: html, encoding: .utf8)

            let fullName =
            String(doc.xpath("//div[@class='field field-name-field-employee-surname field-type-text field-label-hidden']").first?.text ?? "Error") + " " +
            String(doc.xpath("//div[@class='field field-name-field-employee-name field-type-text field-label-hidden']").first?.text ?? "Error") + " " +
            String(doc.xpath("//div[@class='field field-name-field-employee-patronim field-type-text field-label-hidden']").first?.text ?? "Error")

            let departmentFullName = String(doc.xpath("//fieldset[@id='edit-older-subjects']/div[@class='fieldset-wrapper']/h2").first?.text ?? "Error")

            let profileImageUrl = URL(string: String(doc.xpath("//div[@class='field field-name-field-employee-photo field-type-image field-label-hidden']/div[@class='field-items']/div[@class='field-item even']/img/@src").first?.text ?? ""))

            let email = String(doc.xpath("//div[@class='field field-name-field-employee-email field-type-email field-label-inline clearfix']/div[@class='field-items']/div[@class='field-item even']/a").first?.text ?? "")

            let officeAddress = String(doc.xpath("//div[@class='field field-name-field-employee-office field-type-text field-label-inline clearfix']/div[@class='field-items']/div[@class='field-item even']").first?.text ?? "")

            let workPhoneNumber = String(doc.xpath("//div[@class='field-item even']/div[@class='entity entity-field-collection-item field-collection-item-field-employee-phone clearfix']/div[@class='content']/div[@class='field field-name-field-phone-number field-type-phone field-label-inline clearfix']/div[@class='field-items']/div[@class='field-item even']").first?.text ?? "")

            let personalPhoneNumber = String(doc.xpath("//div[@class='field-item odd']/div[@class='entity entity-field-collection-item field-collection-item-field-employee-phone clearfix']/div[@class='content']/div[@class='field field-name-field-phone-number field-type-phone field-label-inline clearfix']/div[@class='field-items']/div[@class='field-item even']").first?.text ?? "")

            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.locale = Locale(identifier: "ru_RU")
            dateFormatter.dateFormat = "d MMMM yyyy"
            let birthdate = dateFormatter.date(from: String(doc.xpath("//div[@class='field field-name-field-employee-birthday field-type-datestamp field-label-inline clearfix']/div[@class='field-items']/div[@class='field-item even']/span[@class='date-display-single']").first?.text ?? ""))

            let teacherLessonsEndpoint = String(doc.xpath("//div[@class='social']/a[1]/@href").first?.text ?? "")

            let teacherSessionEventsEndpoint = String(doc.xpath("//div[@class='social']/a[2]/@href").first?.text ?? "")

            return TeacherDTO(
                fullName: fullName,
                lessonsUrlEndpoint: teacherLessonsEndpoint,
                sessionEventsUrlEndpoint: teacherSessionEventsEndpoint,
                departmentFullName: departmentFullName,
                profileImageUrl: profileImageUrl,
                email: email,
                officeAddress: officeAddress,
                workPhoneNumber: workPhoneNumber,
                personalPhoneNumber: personalPhoneNumber,
                birthdate: birthdate
            )
        } catch {
            throw NetworkError.htmlParserError
        }
    }

    /// Not implemented
    func getAllTeacherSearchResultsFromSource(source html: String) throws -> Set<TeacherSearchResult> {
        throw NetworkError.htmlParserError
    }
}
