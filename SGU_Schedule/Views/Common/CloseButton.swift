//
//  CloseButton.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 29.10.2024.
//

import SwiftUI

struct CloseButton: View {

    var action: () -> Void

    var body: some View {
        Button(
            action: { action() }
        ) {
            MainButton {
                Image(systemName: "multiply")
                    .padding(8)
                    .font(.system(size: 21, weight: .semibold))
            }
        }
    }
}

#Preview {
    CloseButton {
        print("fuck")
    }
}
