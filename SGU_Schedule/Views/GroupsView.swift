//
//  GroupsView.swift
//  SGU_Schedule
//
//  Created by Артемий on 20.09.2023.
//

import SwiftUI

struct GroupsView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [.blue.opacity(0.1), .white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    NavigationLink(destination: ScheduleView()) {
                        GroupSubview(group: Group(FullNumber: 141))
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white.opacity(0.95))
                                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                            )
                            .padding(.horizontal, 13)
                            .padding(.top, 5)
                            .foregroundColor(.black)
                    }
                }
            }
        }
        .accentColor(.black)
    }
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView()
    }
}
