//
//  CarouselView.swift
//  SGU_Schedule
//
//  Created by Артемий on 29.01.2024.
//

import SwiftUI

// Подсмотрено (полностью скопировано) с https://onmyway133.com/posts/how-to-make-carousel-pager-view-in-swiftui/
struct CarouselView<Content: View>: View {
    
    let pageCount: Int
    @State var currentIndex: Int
    @ViewBuilder let content: Content
    
    @GestureState private var translation: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            LazyHStack(alignment: .bottom, spacing: 0) {
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
                        state = value.translation.width
                    }.onEnded { value in
                        let offset = value.translation.width / geometry.size.width
                        let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                        self.currentIndex = min(max(Int(newIndex), 0), 1)
                    }
            )
        }
    }
}

#Preview {
    CarouselView(
        pageCount: 2,
        currentIndex: 0
    ) {
        Text("Теперь я цыган")
        Text("Гы")
    }
}
