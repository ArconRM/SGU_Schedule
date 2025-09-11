//
//  NotAvailableView.swift
//  SGU_ScheduleWidgetExtension
//
//  Created by Artemiy MIROTVORTSEV on 03.08.2024.
//

import SwiftUI

struct NotAvailableView: View {
    @EnvironmentObject var appearanceSettings: AppearanceSettingsStore

    var body: some View {
        Text("Недоступно")
            .font(.system(size: 18, weight: .bold, design: .rounded))
            .foregroundColor(appearanceSettings.currentAppStyle == AppStyle.fill ? .white : .none)
    }
}

#Preview {
    NotAvailableView()
}
