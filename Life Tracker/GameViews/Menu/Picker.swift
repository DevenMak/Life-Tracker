//
//  Picker.swift
//  Life Tracker
//
//  Created by Deven Mak on 3/23/26.
//

import SwiftUI

struct Picker: View {
    @State var rotationAmount: Double = 0
    @State var rotationFinished: Bool = false
    var extraRotation: Double
    var finishText: String
    @Binding var isShowing: Bool
    @Binding var menuShowing: Bool
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Image(systemName: "arrow.down")
                .renderingMode(.template)
                .font(.system(size: 100))
                .foregroundStyle(.white)
                .rotationEffect(.degrees(rotationAmount))
            
            if rotationFinished {
                Text("\(finishText)")
                    .body()
                    .foregroundStyle(.white)
                    .offset(y: 70)
                    .rotationEffect(.degrees(extraRotation))
                    .onAppear {
                        Task {
                            try? await Task.sleep(nanoseconds: 1_500_000_000)
                            withAnimation {
                                isShowing = false
                                menuShowing = false
                            }
                        }
                    }

            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.25).speed(0.1)) {
                rotationAmount = Double(360*Int.random(in: 2...4)) + extraRotation
            } completion: {
                rotationFinished = true
            }
        }
    }
}
