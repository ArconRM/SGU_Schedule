//
//  ErrorView.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 09.06.2024.
//

import SwiftUI

struct ErrorView: View {
    // чтобы не вью не переебашивалось при смене темы (и также источника инета)
    static func == (lhs: ErrorView, rhs: ErrorView) -> Bool {
        return lhs.colorScheme == rhs.colorScheme
    }

    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewsManager: ViewsManager

    @State var error: String

    var body: some View {
        Text(error)
            .font(.system(size: 20))

            .toolbar {
                CloseButton {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewsManager.showGroupsView()
                    }
                }
            }
    }
}

#Preview {
    ErrorView(error: "Что-то пошло не так")
}
