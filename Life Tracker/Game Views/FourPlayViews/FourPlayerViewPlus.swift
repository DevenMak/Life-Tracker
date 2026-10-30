//
//  FourPlayerView.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/25/26.
//

import SwiftUI
import SwiftData

struct FourPlayerViewPlus: View {
    @StateObject private var menuState: MenuState = .shared
    @State var sharedTallySize: CGFloat?
    var game: Game
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ZStack {
                    Color.black.ignoresSafeArea()
                    VStack(spacing: 7) {
                        VerticalPlayer(player: game.players.first(where: {$0.order == 1})!, tallySize: sharedTallySize)
                            .rotationEffect(.degrees(180))
                            .frame(height: UIScreen.main.bounds.height / 4 - 3.5)
                        HStack(spacing: 7) {
                            HorizontalPlayer(player: game.players.first(where: {$0.order == 2})!, tallySize: sharedTallySize)
                                .clipShape(UnevenRoundedRectangle(cornerRad, cornerRad, cornerRad, cornerRad))
                            HorizontalPlayer(player: game.players.first(where: {$0.order == 3})!, tallySize: sharedTallySize)
                                .rotationEffect(.degrees(180))
                                .clipShape(UnevenRoundedRectangle(cornerRad, cornerRad, cornerRad, cornerRad))

                        }
                        VerticalPlayer(player: game.players.first(where: {$0.order == 4})!, tallySize: sharedTallySize)
                            .frame(height: UIScreen.main.bounds.height / 4 - 3.5)
                        
                    }
                    .ignoresSafeArea()
                    
                    MenuButton()
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 4)
                        .ignoresSafeArea()
                }
                .compositingGroup()
                .blur(radius: menuState.showMenu ? 5 : 0)
                
                if menuState.showMenu {
                    Menu(game: game)
                        .zIndex(1)
                }
            }
            .onPreferenceChange(MinSizePreferenceKey.self) { newValue in
                sharedTallySize = newValue.isFinite ? newValue : nil
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
    return FourPlayerViewPlus(game: game)
        .modelContainer(container)
}
