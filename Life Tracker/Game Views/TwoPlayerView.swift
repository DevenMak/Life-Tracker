//
//  2PlayerView.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/13/26.
//

import SwiftUI
import SwiftData

struct TwoPlayerView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var menuState: MenuState = .shared
    var game: Game
    @State var tallySize: CGFloat?
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ZStack {
                    Color.black.ignoresSafeArea()
                    VStack(spacing: 7) {
                        VerticalPlayer(player: game.players.first(where: {$0.order == 1})!, tallySize: tallySize)
                            .rotationEffect(.degrees(180))
                        VerticalPlayer(player: game.players.first(where: {$0.order == 2})!, tallySize: tallySize)
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
            .onPreferenceChange(MinSizePreferenceKey.self) { newValue in
                tallySize = newValue.isFinite ? newValue : nil
            }
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Game.self, configurations: config)

    let game = Game(playerCount: 2, startingLife: 40)
    container.mainContext.insert(game)
    return TwoPlayerView(game: game)
        .modelContainer(container)
}
