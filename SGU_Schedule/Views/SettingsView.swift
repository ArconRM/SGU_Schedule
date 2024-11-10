//
//  SettingsView.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 24.07.2024.
//

import SwiftUI
import WidgetKit

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewsManager: ViewsManager
    @EnvironmentObject var appSettings: AppSettings
    
    public var selectedDepartment: Department
    
    @State var selectedTheme: AppTheme
    @State var selectedStyle: AppStyle
    @State var selectedParser: ParserOptions
    
    var body: some View {
        ZStack {
            appSettings.currentAppTheme.backgroundColor(colorScheme: colorScheme)
                .ignoresSafeArea()
            
            VStack {
                Text(selectedDepartment.fullName)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                Button("Другой факультет") {
                    viewsManager.clearDepartment()
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewsManager.showDepartmentsView()
                    }
                }
                .buttonStyle(BorderedButtonStyle())
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(colorScheme == .light ? .black : .white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom, 15)
                
                Divider()
                    .padding(.trailing, UIDevice.isPhone ? UIScreen.screenWidth / 2 : 0)
                 
                Text("Темы: ")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 15)
                
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
                        appSettings.currentAppThemeValue = newValue.rawValue
                    }
                    
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                }
                
               Text("Стили: ")
                   .font(.system(size: 20, weight: .bold, design: .rounded))
                   .frame(maxWidth: .infinity, alignment: .leading)
                   .padding(.horizontal)
                   .padding(.top, 15)
                
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
                        appSettings.currentAppStyleValue = newValue.rawValue
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                }
                
                Text("Версия сайта\nдля парсинга:")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 15)
                
                Picker("", selection: $selectedParser) {
                    ForEach(ParserOptions.allCases, id: \.self) { parserOption in
                        Text(parserOption.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .frame(maxWidth: 200)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: selectedParser) { newValue in
                    withAnimation(.easeInOut(duration: 0.5)) {
                        viewsManager.changeParser()
                    }
                    
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                }
                
                Spacer()
                
                Text("Версия: \(Bundle.main.appVersion ?? "Хз") (\(Bundle.main.appBuild ?? "Тоже хз")) ")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 50)
                    .padding(.horizontal)
            }
        }
        .alert(isPresented: $viewsManager.isShowingError) {
            Alert(title: Text(viewsManager.activeError?.errorDescription ?? "Error"),
                  message: Text(viewsManager.activeError?.failureReason ?? "Unknown"))
        }
    }
}

#Preview {
    SettingsView(selectedDepartment: Department.mock, selectedTheme: .Blue, selectedStyle: .Fill, selectedParser: .New)
        .environmentObject(ViewsManager(appSettings: AppSettings(), viewModelFactory: ViewModelWithParsingSGUFactory(), viewModelFactory_old: ViewModelWithParsingSGUFactory_old(), schedulePersistenceManager: GroupScheduleCoreDataManager(), groupPersistenceManager: GroupCoreDataManager(), isOpenedFromWidget: false))
        .environmentObject(AppSettings())
}
