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
    
    public var selectedDepartment: DepartmentDTO
    
    @State var selectedTheme: AppTheme
    @State var selectedStyle: AppStyle
    @State var selectedParser: ParserOptions
    @Binding var showTutorial: Bool
    
    var body: some View {
        ZStack {
            AppTheme(rawValue: appSettings.currentAppTheme)?.backgroundColor(colorScheme: colorScheme)
                .ignoresSafeArea()
                .shadow(radius: 5)
            
            VStack {
                Text(selectedDepartment.fullName)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                Button("Сменить факультет") {
                    viewsManager.resetDepartment()
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
                        appSettings.currentAppTheme = newValue.rawValue
                    }
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
                        appSettings.currentAppStyle = newValue.rawValue
                        WidgetCenter.shared.reloadAllTimelines()
                    }
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
                }
                
                Button("Виджеты") {
                    showTutorial.toggle()
                }
                .buttonStyle(BorderedButtonStyle())
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(colorScheme == .light ? .black : .white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                
                Spacer()
            }
        }
        .alert(isPresented: $viewsManager.isShowingError) {
            Alert(title: Text(viewsManager.activeError?.errorDescription ?? "Error"),
                  message: Text(viewsManager.activeError?.failureReason ?? "Unknown"))
        }
    }
}

#Preview {
    SettingsSideMenuView(selectedDepartment: DepartmentDTO(fullName: "knt", code: "knt"), selectedTheme: .Blue, selectedStyle: .Fill, selectedParser: .New, showTutorial: .constant(false))
        .environmentObject(ViewsManager(viewModelFactory: ViewModelWithParsingSGUFactory(), viewModelFactory_old: ViewModelWithParsingSGUFactory_old(), schedulePersistenceManager: GroupScheduleCoreDataManager(), groupPersistenceManager: GroupCoreDataManager(), isOpenedFromWidget: false))
        .environmentObject(AppSettings())
}