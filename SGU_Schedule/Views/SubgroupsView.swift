//
//  SubgroupsView.swift
//  SGU_Schedule
//
//  Created by Artemiy MIROTVORTSEV on 16.10.2024.
//

import SwiftUI

struct SubgroupsView<ViewModel>: View where ViewModel: ScheduleViewModel  {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSettings: AppSettings

    @ObservedObject var viewModel: ViewModel

    @Binding var isShowing: Bool
    
    var body: some View {
        OverlayView(isShowing: $isShowing) {
            ScrollView {
                ForEach(Array(viewModel.subgroupsByLessons.keys), id: \.self) { lesson in
                    VStack {
                        Text(lesson)
                            .font(.system(size: 18, weight: .semibold))
                            .padding(.horizontal)
                        
                        Picker("", selection: Binding (
                            get: {
                                viewModel.subgroupsByLessons[lesson]!.first { $0.isSaved }
                            },
                            set: { selected in
                                if selected != nil {
                                    viewModel.saveSubgroup(lesson: lesson, subgroup: selected!)
                                }
                            }
                        )) {
                            ForEach(viewModel.subgroupsByLessons[lesson]!, id:\.self) { subgroup in
                                Text("\(subgroup.displayNumber)")
                                    .tag(subgroup)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                        .padding(.top, 5)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.vertical)
                }
            }
            
            Divider()
            
            Button("Очистить выбор") {
                viewModel.clearSubgroups()
            }
            .font(.system(size: 19, weight: .bold, design: .rounded))
            .padding(.bottom, 2)
            .padding(.top, 10)
            .foregroundColor(colorScheme == .light ? .black : .white)
            
            Text("Сохраненных: \(viewModel.savedSubgroupsCount)")
                .opacity(0.4)
                .padding(.bottom, 5)
        }
    }
}

#Preview {
    SubgroupsView(
        viewModel: ViewModelWithParsingSGUFactory().buildScheduleViewModel(),
        isShowing: .constant(true)
    )
    .environmentObject(AppSettings())
    .environmentObject(ViewsManager(appSettings: AppSettings(), viewModelFactory: ViewModelWithParsingSGUFactory(), viewModelFactory_old: ViewModelWithParsingSGUFactory_old(), schedulePersistenceManager: GroupScheduleCoreDataManager(), groupPersistenceManager: GroupCoreDataManager(), isOpenedFromWidget: false))
}
