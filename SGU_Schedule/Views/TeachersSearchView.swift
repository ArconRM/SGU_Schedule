//
//  TeachersSearchView.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 28.10.2024.
//

import SwiftUI

struct TeachersSearchView<ViewModel>: View where ViewModel: TeachersSearchViewModel {
    //чтобы не вью не переебашивалось при смене темы (и также источника инета)
    static func == (lhs: TeachersSearchView<TeachersSearchViewModel>, rhs: TeachersSearchView<TeachersSearchViewModel>) -> Bool {
        return lhs.colorScheme == rhs.colorScheme
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel: ViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
    @EnvironmentObject var appSettings: AppSettings
    
    @State private var queryString = ""
    var filteredTeachers: Set<TeacherSearchResult> {
            if queryString.isEmpty {
                return []
            } else {
                return viewModel.allTeachers.filter {
                    $0.fullName.lowercased().hasPrefix(queryString.lowercased())
//                    $0.fullName.localizedCaseInsensitiveContains(queryString)
                }
            }
        }
    
    var body: some View {
        NavigationView {
            ZStack {
                appSettings.currentAppTheme.backgroundColor(colorScheme: colorScheme)
                    .ignoresSafeArea()
                    .shadow(radius: 5)
                
                if viewModel.isLoading {
                    Text("Загрузка всех преподавателей...")
                        .padding(.top)
                        .font(.system(size: 19, weight: .bold, design: .rounded))
                } else {
                    VStack {
                        ScrollView {
                            //TODO: Мб поэффективнее можно
                            ForEach(Array(filteredTeachers), id: \.self) { teacher in
                                PlainTextSubview(text: teacher.fullName)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            viewsManager.showTeacherView(teacherLessonsUrlEndpoint: teacher.lessonsUrlEndpoint)
                                        }
                                    }
                            }
                        }
                        .searchable(text: $queryString, prompt: "Введите фамилию преподавателя")
                        
                        Button(
                            action: {
                                viewModel.needToLoad = true
                            }
                        ) {
                            MainButton {
                                Text("Обновить базу")
                                    .font(.system(size: 19, weight: .bold, design: .rounded))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 15)
                            }
                            .padding(.horizontal)
                        }
                        .alert(isPresented: $viewModel.needToLoad) {
                            Alert(title: Text("Загрузить всю базу?"),
                                  message: Text("Начать загрузку всей базы? Это займет некоторое время."),
                                  primaryButton: .default(
                                    Text("Да"),
                                    action: {
                                        viewModel.fetchNetworkTeachersAndSave()
                                    }
                                  ),
                                  secondaryButton: .default(
                                    Text("Нет"),
                                    action: {
                                        viewModel.needToLoad = false
                                    }
                                  ))
                        }
                        
                        Text("Сохранено: \(viewModel.allTeachers.count)")
                            .padding(.bottom, 5)
                            .padding(.top, 10)
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CloseButton {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewsManager.showGroupsView()
                        }
                    }
                }
            }
            .navigationTitle("Поиск")
        }
        .edgesIgnoringSafeArea(.bottom)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
        .onAppear {
            viewModel.fetchSavedTeachers()
        }
        .alert(isPresented: $viewModel.isShowingError) {
            Alert(title: Text(viewModel.activeError?.errorDescription ?? "Error"),
                  message: Text(viewModel.activeError?.failureReason ?? "Unknown"))
        }
    }
}

#Preview {
    TeachersSearchView(viewModel: ViewModelWithParsingSGUFactory().buildTeachersSearchViewModel())
        .environmentObject(AppSettings())
        .environmentObject(NetworkMonitor())
}
