//
//  ScheduleSubview.swift
//  SGU_Schedule
//
//  Created by Артемий on 19.09.2023.
//

import SwiftUI
import SguParser

struct ScheduleSubview: View, Equatable {
    static func == (lhs: ScheduleSubview, rhs: ScheduleSubview) -> Bool {
        return lhs.lessons == rhs.lessons
    }

    @Namespace private var namespace

    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var viewsManager: ViewsManager
    @EnvironmentObject var appearanceSettings: AppearanceSettingsStore

    var lessons: [LessonDTO]?
    var window: TimeBreakDTO?
    var subgroupsByLessons: [String: [LessonSubgroupDTO]]

    @State var areMultipleLessonsCollapsed: Bool = true

    var body: some View {
        Group {
            if #available(iOS 26, *) {
                content
            } else {
                content
                    .background(colorScheme == .light ? Color.white : Color.gray.opacity(appearanceSettings.currentAppStyle == .fill ? 0.3 : 0.2))
                    .cornerRadius(10)
                    .shadow(
                        color: colorScheme == .light ? .gray.opacity(0.3) : .white.opacity(0.2),
                        radius: 3,
                        x: 0,
                        y: 0
                    )
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        VStack {
            if let window = window {
                makeWindowView(window: window)
            } else if let lessons = lessons {
                if lessons.count == 1 {
                    makeSingleLessonView(lesson: lessons.first!)
                } else if lessons.count >= 1 {
                    makeMultipleLessonsView(lessons: sortLessonsByActive(lessons))
                        .onTapGesture {
                            toggleCollapse()
                        }
                }
            }
        }
    }

    private func toggleCollapse() {
        withAnimation {
            areMultipleLessonsCollapsed.toggle()
        }
    }

    private func makeWindowView(window: TimeBreakDTO) -> some View {
        Group {
            if #available(iOS 26, *) {
                windowContent(window: window)
                    .padding(20)
                    .glassEffect(
                        .regular.interactive(),
                        in: RoundedRectangle(cornerRadius: 20)
                    )
            } else {
                windowContent(window: window)
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .padding(15)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(colorScheme == .light ? .white : Color.gray.opacity(0.3))
                    )
            }
        }
    }

    @ViewBuilder
    private func windowContent(window: TimeBreakDTO) -> some View {
        VStack {
            HStack {
                Text("\(window.timeStart.getHoursAndMinutesString()) - \(window.timeEnd.getHoursAndMinutesString())")
                    .font(.system(size: 17))
                    .bold()

                Spacer()
            }

            Text(window.title)
                .multilineTextAlignment(.center)
                .font(.system(size: 17, weight: .bold))
                .padding(.top, 7)
                .padding(.bottom, 30)
        }
    }

    private func makeSingleLessonView(lesson: LessonDTO, withChevron: Bool = false) -> some View {
        Group {
            if #available(iOS 26, *) {
                singleLessonContent(lesson: lesson, withChevron: withChevron)
                    .padding(20)
                    .background {
                        if appearanceSettings.currentAppStyle != .bordered {
                            getBackground(lesson: lesson)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .opacity(lesson.isActive(subgroupsByLessons: subgroupsByLessons) ? 1 : 0.5)
                    .glassEffect(
                        .regular.interactive(),
                        in: RoundedRectangle(cornerRadius: 20)
                    )
//                    .glassEffectID("\(lesson)", in: namespace)
            } else {
                singleLessonContent(lesson: lesson, withChevron: withChevron)
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .padding(15)
                    .opacity(lesson.isActive(subgroupsByLessons: subgroupsByLessons) ? 1 : 0.5)
                    .background(getBackground(lesson: lesson))
            }
        }
    }

    @ViewBuilder
    private func singleLessonContent(lesson: LessonDTO, withChevron: Bool) -> some View {
        VStack {
            HStack {
                Text("\(lesson.timeStart.getHoursAndMinutesString()) - \(lesson.timeEnd.getHoursAndMinutesString())")
                    .font(.system(size: 17))
                    .bold()

                if lesson.weekType != .all {
                    Text("(\(lesson.weekType.rawValue))")
                        .font(.system(size: 17))
                        .bold()
                }

                Spacer()

                Text(lesson.lessonType.rawValue)
                    .foregroundColor(getLessonColor(lesson: lesson))
                    .font(.system(size: 17))
                    .bold()
            }

            Text(lesson.title)
                .multilineTextAlignment(.center)
                .font(.system(size: 17, weight: .bold))
                .padding(.vertical, 7)

            HStack {
                teacherInfoView(for: lesson)

                Spacer()

                Text("\(lesson.cabinet)")
                    .font(.system(size: 17))
                    .bold()
            }

            if withChevron {
                Image(systemName: "chevron.down")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top, 2)
            }
        }
    }

    @ViewBuilder
    private func teacherInfoView(for lesson: LessonDTO) -> some View {
        let text = lesson.subgroup?.isEmpty == false
            ? "\(lesson.teacherFullName) \n\(lesson.subgroup!)"
            : lesson.teacherFullName

        Text(text)
            .font(.system(size: 17))
            .italic()
            .underline(lesson.teacherEndpoint != nil)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if lesson.teacherEndpoint != nil && networkMonitor.isConnected {
                        viewsManager.showTeacherView(teacherUrlEndpoint: lesson.teacherEndpoint!)
                    }
                }
            }
    }

    private func makeMultipleLessonsView(lessons: [LessonDTO]) -> some View {
        if #available(iOS 26, *) {
            return GlassEffectContainer {
                VStack {
                    if areMultipleLessonsCollapsed {
                        makeSingleLessonView(lesson: sortLessonsByActive(lessons).first!, withChevron: true)
                    } else {
                        VStack {
                            ForEach(lessons, id: \.self) { lesson in
                                singleLessonContent(lesson: lesson, withChevron: false)
                                    .padding(20)
                                    .background {
                                        if appearanceSettings.currentAppStyle != .bordered {
                                            getBackground(lesson: lesson)
                                        }
                                    }
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .opacity(lesson.isActive(subgroupsByLessons: subgroupsByLessons) ? 1 : 0.5)
                                    .glassEffect(
                                        .regular.interactive(),
                                        in: RoundedRectangle(cornerRadius: 20)
                                    )
//                                    .glassEffectID("\(lesson)", in: namespace)
                            }
                        }
                        .background(colorScheme == .light ? .white.opacity(0.8) : .gray.opacity(0.5))
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        } else {
            return VStack {
                if areMultipleLessonsCollapsed {
                    makeSingleLessonView(lesson: sortLessonsByActive(lessons).first!, withChevron: true)
                } else {
                    ForEach(lessons, id: \.self) { lesson in
                        singleLessonContent(lesson: lesson, withChevron: false)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .padding(15)
                            .opacity(lesson.isActive(subgroupsByLessons: subgroupsByLessons) ? 1 : 0.5)
                            .background {
                                if appearanceSettings.currentAppStyle != .bordered {
                                    getBackground(lesson: lesson)
                                }
                            }
                            .overlay {
                                if appearanceSettings.currentAppStyle == .bordered {
                                    Divider()
                                        .offset(y: 0.5)
                                }
                            }
                    }
                }
            }
        }
    }

    private func sortLessonsByActive(_ lessons: [LessonDTO]) -> [LessonDTO] {
        return lessons.filter({ $0.isActive(subgroupsByLessons: subgroupsByLessons) }) +
        lessons.filter({ !$0.isActive(subgroupsByLessons: subgroupsByLessons) })
    }

    private func getBackground(lesson: LessonDTO) -> AnyView {
        switch appearanceSettings.currentAppStyle {
        case .fill:
            AnyView(
                getLessonColor(lesson: lesson).opacity(0.3)
            )
        case .bordered:
            AnyView(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(getLessonColor(lesson: lesson).opacity(0.5), lineWidth: 7)
            )
        }
    }

    private func getLessonColor(lesson: LessonDTO) -> Color {
        lesson.isActive(subgroupsByLessons: subgroupsByLessons) ?
        (lesson.lessonType == .lecture ? Color.green : Color.blue)
        : Color.gray
    }
}

 struct ScheduleSubview_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.gray)
                .ignoresSafeArea()
            ScrollView {
                ScheduleSubview(
                    lessons: [
                        LessonDTO(subject: "Основы Российской государственности",
                                  teacherFullName: "Бредихин Д. А.",
                                  teacherEndpoint: "/person/bredihin-dmitriy-aleksandrovich",
                                  lessonType: .lecture,
                                  weekDay: .monday,
                                  weekType: .numerator,
                                  cabinet: "12 корпус ауд.303",
                                  lessonNumber: 1,
                                  timeStart: "08:20",
                                  timeEnd: "09:50"),

                        LessonDTO(subject: "Основы Российской государственности",
                                  teacherFullName: "Бредихин Д. А.",
                                  lessonType: .practice,
                                  weekDay: .monday,
                                  weekType: .denumerator,
                                  cabinet: "12 корпус ауд.303",
                                  lessonNumber: 1,
                                  timeStart: "08:20",
                                  timeEnd: "09:50")
                    ], subgroupsByLessons: [String: [LessonSubgroupDTO]]()
                )
                .environmentObject(ViewsManager(appearanceSettings: AppearanceSettingsStore(), persistentUserSettings: PersistentUserSettingsStore(), routingState: RoutingState(), viewModelFactory: ViewModelWithMockDataFactory(), groupSchedulePersistenceManager: GroupSchedulePersistenceManagerMock(), groupSessionEventsPersistenceManager: GroupSessionEventsPersistenceManagerMock(), groupPersistenceManager: GroupPersistenceManagerMock(), notificationManager: NotificationManagerMock(groupPersistenceManager: GroupPersistenceManagerMock())))
                .environmentObject(NetworkMonitor())
                .environmentObject(AppearanceSettingsStore())
                .padding(.horizontal)
            }
        }
    }
 }
