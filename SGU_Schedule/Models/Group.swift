//
//  Group.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import Foundation

public struct Group {
//    var Year: Int
//    var GroupId: Int
//    var SubgroupNumber: Int
    var FullNumber: Int
    var ShortName: String
    var FullName: String
    
public init(FullNumber: Int) {
        self.FullNumber = FullNumber
        
        let source = GroupsSource(rawValue: self.FullNumber) //костыль, ибо нет списка нормального
        self.ShortName = source?.shortName ?? "Error"
        self.FullName = source?.fullName ?? "Error"
    }
}
