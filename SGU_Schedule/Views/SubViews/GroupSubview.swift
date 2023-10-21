//
//  GroupSubview.swift
//  SGU_Schedule
//
//  Created by Артемий on 20.09.2023.
//

import SwiftUI

struct GroupSubview: View {
    @Environment(\.colorScheme) var colorScheme
    
    var group: Group
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Rectangle()
                        .cornerRadius(10)
                        .foregroundColor(.cyan.opacity(0.3))
                        .shadow(color: .cyan.opacity(0.7), radius: 7, x: 2, y: 2)
                        .blur(radius: 1)
                    
                    Text(String(group.fullNumber))
                        .foregroundColor(colorScheme == .light ? .black : .white)
                        .font(.custom("arial", size: 20))
                        .bold()
                }
                .frame(maxWidth: 90, maxHeight: 120)
                
                Text(group.fullName)
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .font(.custom("arial", size: 18))
                    .multilineTextAlignment(.leading)
                    .bold()
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
                .foregroundColor(.blue.opacity(0.2))
                .ignoresSafeArea()
            
            GroupSubview(group: Group(fullNumber: 141))
        }
    }
}
