//
//  GroupsView.swift
//  Watch_SGU_Schedule Watch App
//
//  Created by Артемий on 24.11.2023.
//

import SwiftUI

struct GroupsView<ViewModel>: View where ViewModel: GroupsViewModel {
    
    @ObservedObject var viewModel: ViewModel
    
    @State private var selectedAcademicProgram = AcademicProgram.BachelorAndSpeciality
    @State private var selectedYear = 1
    
    @Binding var selectedGroupNumber: Int?
    
    var body: some View {
        NavigationView {
            ScrollView {
                Picker(selection: $selectedAcademicProgram) {
                    ForEach(AcademicProgram.allCases, id:\.self) { program in
                        Text(program.rawValue)
                            .tag(program)
                            .font(.system(size: 15, weight: .bold))
                    }
                } label: {
                    Text(selectedAcademicProgram.rawValue)
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(height: 60.0)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 11)
//                        .stroke(Color.black, lineWidth: 4)
//                        .offset(y: 0)
//                        .padding(.top, 17)
//                )
                .onChange(of: selectedAcademicProgram) { newValue in
                    viewModel.fetchGroups(year: selectedYear, academicProgram: selectedAcademicProgram)
                }
                
                
                Picker(selection: $selectedYear) {
                    ForEach(1..<7) {
                        Text("\($0) курс")
                            .tag($0)
                    }
                } label: {
                    Text(String(selectedYear) + " курс")
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(height: 60.0)
                .padding(.bottom, 10)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 11)
//                        .stroke(Color.black, lineWidth: 4)
//                        .offset(y: 0)
//                        .padding(.top, 17)
//                )
                .onChange(of: selectedYear) { newValue in
                    viewModel.fetchGroups(year: selectedYear, academicProgram: selectedAcademicProgram)
                }
                
                
                if viewModel.isLoadingGroups {
                    Spacer()
                    
                    Text("Загрузка...")
                        .padding(.top)
                        .font(.system(size: 19, weight: .bold))
                    
                    Spacer()
                } else {
                    ForEach(viewModel.groups, id:\.self) { group in
                        GroupSubview(group: group)
                            .onTapGesture {
                                selectedGroupNumber = group.fullNumber
                            }
                    }
                }
            }
            .padding(.top, 12)
        }
        .accentColor(.white)
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchGroups(year: selectedYear, academicProgram: selectedAcademicProgram)
        }
    }
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView(viewModel: GroupsViewModelWithParsingSGU(), selectedGroupNumber: .constant(141))
    }
}
