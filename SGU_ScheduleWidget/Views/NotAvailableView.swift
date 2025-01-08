//
//  NotAvailableView.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 03.08.2024.
//

import SwiftUI

struct NotAvailableView: View {
    @EnvironmentObject var appSettings: AppSettings

    var body: some View {
        Text("Недоступно")
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .foregroundColor(appSettings.currentAppStyle == AppStyle.fill ? .white : .none)
    }
}

#Preview {
    NotAvailableView()
}
