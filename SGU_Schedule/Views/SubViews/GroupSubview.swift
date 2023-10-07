//
//  GroupSubview.swift
//  SGU_Schedule
//
//  Created by Артемий on 20.09.2023.
//

import SwiftUI

struct GroupSubview: View {
    
    var group: Group
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    Rectangle()
                        .cornerRadius(10)
                        .foregroundColor(.cyan.opacity(0.25))
                    Text(String(group.FullNumber))
                        .foregroundColor(.black)
                        .font(.custom("arial", size: 20))
                        .bold()
                }
                .frame(maxWidth: 90, maxHeight: 120)
                
                Text(group.FullName)
                    .font(.custom("arial", size: 18))
                    .multilineTextAlignment(.leading)
                    .bold()
                    .padding(.vertical, 20)
                
                Spacer()
            }
        }
//        .padding(.horizontal)
    }
}

struct GroupSubview_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.gray.opacity(0.2))
            
            GroupSubview(group: Group(FullNumber: 141))
        }
    }
}
