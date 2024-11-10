//
//  TeacherInfoView.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 31.05.2024.
//

import SwiftUI

struct TeacherInfoView: View {
    //чтобы не вью не переебашивалось при смене темы (и также источника инета)
    static func == (lhs: TeacherInfoView, rhs: TeacherInfoView) -> Bool {
        return lhs.colorScheme == rhs.colorScheme
    }
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSettings: AppSettings
    
    @State var teacher: Teacher
    
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
                    .padding(10)
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
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .foregroundColor(colorScheme == .light ? .black : .white)
        .background(getBackground())
        .onTapGesture {
            withAnimation(.bouncy(duration: 0.5)) {
                isCollapsed.toggle()
            }
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
    }
    
    private func getBackground() -> AnyView {
        switch appSettings.currentAppStyle {
        case .Fill:
            AnyView(
                RoundedRectangle(cornerRadius: 20)
                    .fill(colorScheme == .light ? .white : .white.opacity(0.1))
                    .shadow(color: .gray.opacity(0.25), radius: 5, x: 0, y: 5)
                    .blur(radius: 0.5)
            )
        case .Bordered:
            AnyView(
                ZStack {
                    (colorScheme == .light ? Color.white : Color.white.opacity(0.1))
                        .cornerRadius(20)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(appSettings.currentAppTheme.foregroundColor(colorScheme: colorScheme).opacity(0.6), lineWidth: 4)
                }
            )
        }
    }
}

#Preview {
    ZStack {
        AppTheme.Blue.backgroundColor(colorScheme: .dark)
            .ignoresSafeArea()
            .shadow(radius: 5)
        
        TeacherInfoView(
            teacher: Teacher(
                fullName: "Осипцев Михаил Анатольевич",
                lessonsEndpoint: "/schedule/teacher/475",
                sessionEventsEndpoint: "/schedule/teacher/475#session",
                departmentFullName: "Мех Мат",
                profileImageUrl: URL(string: "https://www.old1.sgu.ru/sites/default/files/styles/500x375_4x3/public/employee/facepics/7a630f4a70a5310d9152a3d5e5350a35/foto-1.jpg?itok=IILG1z3i")!,
                email: "Osipcevm@gmail.com",
                officeAddress: "9 учебный корпус СГУ, ком. 316",
                workPhoneNumber: "+7 (8452) 51 - 55 - 37",
                personalPhoneNumber: nil,
                birthdate: Date.now
            )
        )
        .environmentObject(AppSettings())
    }
}
