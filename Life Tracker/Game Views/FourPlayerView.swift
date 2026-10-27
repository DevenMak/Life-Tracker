//
//  FourPlayerView.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/25/26.
//

import SwiftUI
import SwiftData

struct FourPlayerView: View {
    @StateObject private var menuState: MenuState = .shared

    var game: Game
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ZStack {
                    Color.black.ignoresSafeArea()
                    HStack(spacing: 7) {
                        VStack(spacing: 7) {
                            HorizontalPlayer(player: game.players.first(where: {$0.order == 1})!)
                                .clipShape(UnevenRoundedRectangle(0, cornerRad, 0, cornerRad))
                            HorizontalPlayer(player: game.players.first(where: {$0.order == 2})!)
                                .clipShape(UnevenRoundedRectangle(cornerRad, 0, cornerRad, 0))

                        }
                        VStack(spacing: 7) {
                            HorizontalPlayer(player: game.players.first(where: {$0.order == 3})!)
                                .clipShape(UnevenRoundedRectangle(cornerRad, 0, cornerRad, 0))
                                .rotationEffect(.degrees(180))
                            HorizontalPlayer(player: game.players.first(where: {$0.order == 4})!)
                                .clipShape(UnevenRoundedRectangle(0, cornerRad, 0, cornerRad))
                                .rotationEffect(.degrees(180))
                                
                        }
                    }
                    .ignoresSafeArea()
                    
                    MenuButton()
                        .offset(y: -0.5*(geo.safeAreaInsets.top-geo.safeAreaInsets.bottom))
                }
                .compositingGroup()
                .blur(radius: menuState.showMenu ? 5 : 0)
                
                if menuState.showMenu {
                    Menu(game: game)
                        .zIndex(1)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Game.self, configurations: config)

    let game = Game(playerCount: 4, startingLife: 20)
    for player in game.players {
        player.tallies[0].order = 2
    }
    container.mainContext.insert(game)
    return FourPlayerView(game: game)
        .modelContainer(container)
}
