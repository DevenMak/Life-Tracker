//
//  SwiftUIView.swift
//  Life Tracker
//
//  Created by Deven Mak on 7/31/26.
//

import SwiftUI

class TestCoordinator: ObservableObject {
    public static var shared = TestCoordinator()
    @Published var toggleRectangle: Bool = false
}

struct SwiftUIView: View {
    @StateObject var coordinator: TestCoordinator = .shared
    @State var showText: Bool = true
    var body: some View {
        ZStack {
            Color.green
               // .zIndex(-100)
            Button(action: {
                withAnimation {
                    coordinator.toggleRectangle.toggle()
                }
            }) {
                Text("Toggle text")
            }
            .offset(y: -200)
            if coordinator.toggleRectangle {
                Rectangle()
                    .fill(.red)
                    .frame(width: 200, height: 200)
                    .position(x: 300, y: 300)
                    .transition(
                        ZoomTransition(
                            size: CGSize(width: 200, height: 200),
                            x: 300,
                            y: 300
                        )
                    )
                   // .zIndex(100)
            }
        }
        .ignoresSafeArea(.all)

    }
}


#Preview {
    SwiftUIView()
}
