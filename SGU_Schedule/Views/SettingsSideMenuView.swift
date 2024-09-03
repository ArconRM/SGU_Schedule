//
//  SettingsSideMenuView.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 24.07.2024.
//

import SwiftUI
import WidgetKit

struct SettingsSideMenuView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewsManager: ViewsManager
    @EnvironmentObject var appSettings: AppSettings
    @State var selectedTheme: AppTheme
    @State var selectedStyle: AppStyle
    
    @State var showError: Bool = false
    var error: LocalizedError? = nil
    
    var body: some View {
        ZStack {
            AppTheme(rawValue: appSettings.currentAppTheme)?.backgroundColor(colorScheme: colorScheme)
                .ignoresSafeArea()
                .shadow(radius: 5)
            
            VStack {
                Text(viewsManager.getSelectedDapertmentFullName())
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                Button("Сменить факультет") {
                    do {
                        try viewsManager.resetDepartment()
                    }
                    catch {
                        showError.toggle()
                    }
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewsManager.showDepartmentsView()
                    }
                    
                }
                .buttonStyle(BorderedButtonStyle())
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(colorScheme == .light ? .black : .white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom)
                
                Divider()
                 
                Text("Темы: ")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                    .padding(.horizontal)
                
                Picker("", selection: $selectedTheme) {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        Text(theme.rusValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .frame(maxWidth: 200)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: selectedTheme) { newValue in
                    withAnimation(.bouncy(duration: 0.5)) {
                        appSettings.currentAppTheme = newValue.rawValue
                    }
                }
                
               Text("Стили: ")
                   .font(.system(size: 20, weight: .bold, design: .rounded))
                   .frame(maxWidth: .infinity, alignment: .leading)
                   .padding(.top)
                   .padding(.horizontal)
                
                Picker("", selection: $selectedStyle) {
                    ForEach(AppStyle.allCases, id: \.self) { style in
                        Text(style.rusValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .frame(maxWidth: 200)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: selectedStyle) { newValue in
                    withAnimation(.bouncy(duration: 0.5)) {
                        appSettings.currentAppStyle = newValue.rawValue
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                }
                
                Spacer()
            }
        }
        .alert(isPresented: $showError) {
            Alert(title: Text(error?.errorDescription ?? "Error"),
                  message: Text(error?.failureReason ?? "Unknown"))
        }
    }
}

#Preview {
    SettingsSideMenuView(selectedTheme: .blue, selectedStyle: .fill)
        .environmentObject(ViewsManager(viewModelFactory: ViewModelWithParsingSGUFactory(), schedulePersistenceManager: GroupScheduleCoreDataManager()))
        .environmentObject(AppSettings())
}
