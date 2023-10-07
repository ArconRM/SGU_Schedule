//
//  NetworkManagerWithParsing.swift
//  SGU_Schedule
//
//  Created by Артемий on 30.09.2023.
//

import Foundation

protocol NetworkManagerWithParsing : NetworkManager {
    func getHTML(group: Group, completionHandler: @escaping(Result<String, Error>) -> Void)
}
