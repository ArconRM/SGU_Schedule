//
//  GroupSubview.swift
//  Watch_SGU_Schedule Watch App
//
//  Created by Артемий on 24.11.2023.
//

import SwiftUI

struct GroupSubview: View {
    @State var group: GroupDTO
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .cornerRadius(10)
                    .foregroundColor(.cyan.opacity(0.3))
                    .shadow(color: .cyan.opacity(0.7),
                            radius: 7,
                            x: 2,
                            y: 2)
                    .blur(radius: 1)
                    .frame(height: 45)
                
                Text(String(group.fullNumber))
                    .foregroundColor(.white)
                    .font(.system(size: 15))
                    .bold()
            }
            
            Text(group.shortName)
                .foregroundColor(.white)
                .font(.system(size: 15, weight: .bold))
                .multilineTextAlignment(.leading)
                .padding(.top, 10)
            
            Spacer()
        }
        .cornerRadius(10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white.opacity(0.2))
                .shadow(color: .gray.opacity(0.25), 
                        radius: 5,
                        x: 0,
                        y: 5)
                .blur(radius: 0.5)
        )
        .frame(minHeight: 100, maxHeight: 120)
    }
}

struct GroupSubview_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            GroupSubview(group: GroupDTO(fullNumber: 141))
            GroupSubview(group: GroupDTO(fullNumber: 131))
            GroupSubview(group: GroupDTO(fullNumber: 161))
            GroupSubview(group: GroupDTO(fullNumber: 151))
            GroupSubview(group: GroupDTO(fullNumber: 111))
        }
    }
}
