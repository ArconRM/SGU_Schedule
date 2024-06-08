//
//  SessionEventSubview.swift
//  SGU_Schedule
//
//  Created by Артемий on 28.01.2024.
//

import SwiftUI

struct SessionEventSubview: View {
    @Environment(\.colorScheme) var colorScheme
    
    let sessionEvent: SessionEventDTO
    
    var body: some View {
        VStack {
            VStack {
                Text(sessionEvent.title)
                    .font(.system(size: 20))
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text(sessionEvent.sessionEventType.rawValue)
                    .font(.system(size: 17))
                    .italic()
                    .multilineTextAlignment(.center)
                
                HStack {
                    Text(sessionEvent.date.getDayMonthAndYearString())
                        .font(.system(size: 20))
                        .bold()
                    
                    Text(sessionEvent.date.getHoursAndMinutesString())
                        .font(.system(size: 20))
                }
                .padding(.vertical, 10)
                
                HStack {
                    Text(sessionEvent.cabinet)
                        .font(.system(size: 17))
                    
                    Spacer()
                    
                    Text(sessionEvent.teacherFullName)
                        .font(.system(size: 17))
                        .italic()
                }
            }
            .foregroundColor(colorScheme == .light ? .black : .white)
            .padding(15)
            .opacity(sessionEvent.date.passed() ? 0.5 : 1)
            .background(getBackground())
        }
        .background(colorScheme == .light ? Color.white : Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal, 13)
        .shadow(color: colorScheme == .light ?
            .gray.opacity(0.3) :
                .white.opacity(0.2),
                radius: 3,
                x: 0,
                y: 0)
    }
    
    private func getBackground() -> Color {
        if sessionEvent.date.passed() {
            .gray.opacity(0.1)
        } else {
            if sessionEvent.sessionEventType == .Consultation {
                .green.opacity(sessionEvent.date.isAroundNow() ? 0.6 : 0.2)
            } else {
                if sessionEvent.date.isAroundNow() {
                    .yellow.opacity(0.6)
                } else {
                    .blue.opacity(0.2)
                }
            }
        }
    }
}

#Preview {
    ScrollView {
        SessionEventSubview(sessionEvent: SessionEventDTO(title: "Иностранный язык (анг)",
                                                          date: Date.now,
                                                          sessionEventType: .Exam,
                                                          teacherFullName: "Алексеева Дина Алексеевна",
                                                          cabinet: "12 корпус ауд.302"))
        
        SessionEventSubview(sessionEvent: SessionEventDTO(title: "Иностранный язык (анг)",
                                                          date: "29 января 2025 21:00",
                                                          sessionEventType: .Exam,
                                                          teacherFullName: "Алексеева Дина Алексеевна",
                                                          cabinet: "12 корпус ауд.302"))
        
        SessionEventSubview(sessionEvent: SessionEventDTO(title: "Иностранный язык (анг)",
                                                          date: "29 января 2023 21:00",
                                                          sessionEventType: .Test,
                                                          teacherFullName: "Алексеева Дина Алексеевна",
                                                          cabinet: "12 корпус ауд.302"))
        
        SessionEventSubview(sessionEvent: SessionEventDTO(title: "Иностранный язык (анг)",
                                                          date: "29 января 2023 21:00",
                                                          sessionEventType: .TestWithMark,
                                                          teacherFullName: "Алексеева Дина Алексеевна",
                                                          cabinet: "12 корпус ауд.302"))
    }
}
