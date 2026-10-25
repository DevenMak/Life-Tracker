//
//  LifeSelection.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/20/26.
//

import SwiftUI

struct LifeSelection: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("Life Selection")
                    .heading()
                    .foregroundStyle(.white)
                    .padding()
                Spacer()
            }
            VStack(spacing: 100) {
                Button(action: {
                    GameSettings.shared.startingLife = 20
                    Path.shared.navPath.append(Route.playerCountSelection)
                }) {
                    ZStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 43))
                            .foregroundStyle(.accent)
                        Text("20")
                            .rubikMedium(80)
                            .foregroundStyle(.white)
                            .opacity(0.65)
                    }
                }
                Button(action: {
                    GameSettings.shared.startingLife = 40
                    Path.shared.navPath.append(Route.playerCountSelection)
                }) {
                    ZStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 43))
                            .foregroundStyle(.accent)
                        Text("40")
                            .rubikMedium(80)
                            .foregroundStyle(.white)
                            .opacity(0.65)
                    }
                }
            }
        }
    }
}

#Preview {
    LifeSelection()
}
