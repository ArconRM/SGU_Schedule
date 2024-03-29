//
//  GroupSubview.swift
//  SGU_Schedule
//
//  Created by Артемий on 20.09.2023.
//

import SwiftUI

struct GroupSubview: View {
    @Environment(\.colorScheme) var colorScheme
    
    var group: GroupDTO
    var isFavorite: Bool
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Rectangle()
                        .cornerRadius(10)
                        .foregroundColor(isFavorite ? .cyan.opacity(0.6) : .cyan.opacity(0.3))
                        .shadow(color: .cyan.opacity(0.7), radius: 7, x: 2, y: 2)
                        .blur(radius: 1)
                    
                    Text(String(group.fullNumber))
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        .font(.system(size: 20))
                        .bold()
                }
                .frame(maxWidth: 90)
                
                Text(group.fullName)
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .font(.system(size: 18, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 20)
                
                Spacer()
            }
        }
        .cornerRadius(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .light ? .white : .white.opacity(0.2))
                .shadow(color: .gray.opacity(0.25), radius: 5, x: 0, y: 5)
                .blur(radius: 0.5)
        )
        .padding(.horizontal, 13)
        .padding(.top, 5)
        .frame(minHeight:100)
    }
}

struct GroupSubview_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.blue.opacity(0.1))
                .ignoresSafeArea()
            ScrollView {
                GroupSubview(group: GroupDTO(fullNumber: 141), isFavorite: true)
                GroupSubview(group: GroupDTO(fullNumber: 131), isFavorite: false)
            }
        }
    }
}
