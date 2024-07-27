//
//  TeacherInfoCardView.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 31.05.2024.
//

import SwiftUI

struct TeacherInfoCardView: View {
    //чтобы не вью не переебашивалось при смене темы (и также источника инета)
    static func == (lhs: TeacherInfoCardView, rhs: TeacherInfoCardView) -> Bool {
        return lhs.colorScheme == rhs.colorScheme
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var teacher: TeacherDTO
    
    @State var isCollapsed: Bool = false
    
    var body: some View {
        VStack {
//            Image("foto-1")
//                .resizable()
//                .aspectRatio(contentMode: ContentMode.fit)
//                .cornerRadius(20)
//                .padding(2)
            
            AsyncImage(url: teacher.profileImageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fit)
                    .cornerRadius(20)
                    .shadow(radius: 3)
            } placeholder: {
                ProgressView()
            }
            
            Divider()
            
            Text(teacher.fullName)
                .font(.system(size: 18))
                .bold()
                .padding(.vertical, self.isCollapsed ? 5 : 10)
            
            if !self.isCollapsed {
                
                Text("Дата рождения: " + (teacher.birthdate?.getDayMonthAndYearString() ?? ""))
                
                Text("Email: " + (teacher.email ?? ""))
                
                Text("Рабочий телефон: " + (teacher.workPhoneNumber ?? ""))
                
                Text("Личный телефон: " + (teacher.personalPhoneNumber ?? ""))
                
//                Image(systemName: "chevron.up")
//                    .font(.system(size: 10))
//                    .padding(.top, 2)
                
            } else {
//                Image(systemName: "chevron.down")
//                    .font(.system(size: 20))
//                    .padding(.top, -1)
                
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .foregroundColor(colorScheme == .light ? .black : .white)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .light ? .white : .white.opacity(0.2))
                .shadow(color: .gray.opacity(0.25), radius: 5, x: 0, y: 5)
                .blur(radius: 0.5)
            )
//        .cornerRadius(20)
        .onTapGesture {
            withAnimation(.bouncy(duration: 0.5)) {
                isCollapsed.toggle()
            }
        }
    }
}

#Preview {
    ZStack {
        AppTheme.blue.backgroundColor(colorScheme: .dark)
            .ignoresSafeArea()
            .shadow(radius: 5)
        
        TeacherInfoCardView(
            teacher: TeacherDTO(
                fullName: "Осипцев Михаил Анатольевич",
                profileImageUrl: URL(string: "https://www.old.sgu.ru/sites/default/files/styles/500x375_4x3/public/employee/facepics/7a630f4a70a5310d9152a3d5e5350a35/foto-1.jpg?itok=IILG1z3i")!,
                email: "Osipcevm@gmail.com",
                officeAddress: "9 учебный корпус СГУ, ком. 316",
                workPhoneNumber: "+7 (8452) 51 - 55 - 37",
                personalPhoneNumber: nil,
                birthdate: Date.now,
                teacherLessonsEndpoint: "/schedule/teacher/475",
                teacherSessionEventsEndpoint: "/schedule/teacher/475#session"
            )
        )
    }
}
