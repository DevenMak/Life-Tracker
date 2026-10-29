//
//  ThreePlayerViewY.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/26/26.
//

import SwiftUI
import SwiftData

struct ThreePlayerViewY: View {
    @StateObject var menuState = MenuState.shared
    @State var sharedTallySize: CGFloat?
    var game: Game
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.black
                ZStack {
                    VStack(spacing: 7) {
                        HStack(spacing: 7) {
                            HorizontalPlayer(player: game.players.first(where: {$0.order == 1})!, tallySize: sharedTallySize)
                                .clipShape(UnevenRoundedRectangle(0, cornerRad, 0, cornerRad))
                            
                            HorizontalPlayer(player: game.players.first(where: {$0.order == 2})!, tallySize: sharedTallySize)
                                .clipShape(UnevenRoundedRectangle(cornerRad, 0, cornerRad, 0))
                                .rotationEffect(.degrees(180))
                            
                            
                        }
                        VerticalPlayer(player: game.players.first(where: {$0.order == 3})!, tallySize: sharedTallySize)
                            .frame(height: UIScreen.main.bounds.height/7*3)
                        
                    }
                    MenuButton()
                        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 7 * 4 - 3.5)
                }
                .compositingGroup()
                .blur(radius: menuState.showMenu ? 5 : 0)
                
                if menuState.showMenu {
                    Menu(game: game)
                        .zIndex(1)
                }
            }
            .ignoresSafeArea()
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

    let game = Game(playerCount: 3, startingLife: 20)
    for player in game.players {
        player.tallies[0].order = 2
    }
    container.mainContext.insert(game)
    return ThreePlayerViewY(game: game)
        .modelContainer(container)
}
