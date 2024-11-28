//
//  CarouselView.swift
//  SGU_Schedule
//
//  Created by Артемий on 29.01.2024.
//

import SwiftUI

// Подсмотрено (полностью скопировано и чуть настроено) с https://onmyway133.com/posts/how-to-make-carousel-pager-view-in-swiftui/
struct CarouselView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSettings: AppSettings

    let pages: [String]
    @State var currentIndex: Int

    let viewsAlignment: VerticalAlignment
    @ViewBuilder let content: Content

    @GestureState private var translation: CGFloat = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { geometry in
                LazyHStack(alignment: viewsAlignment, spacing: 0) {
                    self.content.frame(width: geometry.size.width)
                }
                .frame(width: geometry.size.width, alignment: .leading)
                .offset(x: -CGFloat(self.currentIndex) * geometry.size.width)
                .offset(x: self.translation)
                .animation(.interactiveSpring(), value: currentIndex)
                .animation(.interactiveSpring(), value: translation)
                .gesture(
                    DragGesture()
                        .updating(self.$translation) { value, state, _ in
                            if currentIndex == 0 && value.translation.width < 0 || currentIndex == 1 && value.translation.width > 0 {
                                state = value.translation.width
                            }
                        }.onEnded { value in
                            let offset = value.translation.width / geometry.size.width + (value.translation.width >= 0 ? UIScreen.screenWidth / 3 : -UIScreen.screenWidth / 3)
                            let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                            self.currentIndex = min(max(Int(newIndex), 0), 1)
                        }
                )
            }

            HStack {
                ForEach(pages, id: \.self) { title in
                    Text(title)
                        .font(.system(size: pages[currentIndex] == title ? 18 : 13))
                        .fontWeight(pages[currentIndex] == title ? .bold : .regular)
                        .onTapGesture {
                            currentIndex = pages.firstIndex(of: title) ?? 0
                        }
                }
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 20)
            .background {
                ZStack {
                    colorScheme == .light ? Color.white : Color.black

                    appSettings.currentAppTheme.backgroundColor(colorScheme: colorScheme).blur(radius: 2)
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    CarouselView(
        pages: ["Цыган", "Чё"],
        currentIndex: 0,
        viewsAlignment: .bottom
    ) {
        Text("Теперь я цыган")
            .frame(width: 393, height: 500)
            .background(.red)

        Text("Гы")
            .frame(width: 393, height: 400)
            .background(.blue)
    }
    .environmentObject(AppSettings())
}
