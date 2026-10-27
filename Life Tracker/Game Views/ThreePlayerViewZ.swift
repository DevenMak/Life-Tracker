//
//  ThreePlayerViewL.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/26/26.
//

import SwiftUI
import SwiftData

struct ThreePlayerViewZ: View {
    @StateObject var menuState = MenuState.shared
    var game: Game
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black
                ZStack {
                        VStack(spacing: 7) {
                            HorizontalPlayer(player: game.players.first(where: {$0.order == 1})!)
                                .clipShape(UnevenRoundedRectangle(0, cornerRad, cornerRad, 0))
                            
                            HorizontalPlayer(player: game.players.first(where: {$0.order == 2})!)
                                .clipShape(UnevenRoundedRectangle(cornerRad, cornerRad, cornerRad, cornerRad))
                                .rotationEffect(.degrees(180))
                            HorizontalPlayer(player: game.players.first(where: {$0.order == 3})!)
                                .clipShape(UnevenRoundedRectangle(cornerRad,0,0,cornerRad))
                        }
                        
                    MenuButton()
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 3)
                }
                .compositingGroup()
                .blur(radius: menuState.showMenu ? 5 : 0)
                
                if menuState.showMenu {
                    Menu(game: game)
                        .zIndex(1)
                }
            }
            .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Game.self, configurations: config)

    let game = Game(playerCount: 3, startingLife: 20)
    for player in game.players {
        player.tallies[0].order = 2
    }
    container.mainContext.insert(game)
    return ThreePlayerViewZ(game: game)
        .modelContainer(container)
}
