//
//  PlayerCountSelection.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/15/26.
//

import SwiftUI
import SwiftData

class GameSettings: ObservableObject {
    public static var shared = GameSettings()
    @Published var playerCount: Int = 0
    @Published var startingLife: Int = 0
    @Published var game: Game?
}

struct PlayerCountSelection: View {
    @StateObject var gameSettings: GameSettings = .shared
    @Environment(\.modelContext) private var context
    @Query private var games: [Game]
    var body: some View {
        Button(action: {
            gameSettings.playerCount = 2
            startNewGame()
            Path.shared.navPath.append(Route.twoPlayerView)
        }) {
            Text("2 Player Game")
        }
        
        Button(action: {
            
        }) {
            
        }
    }
    
    func startNewGame() {
        let game = Game(playerCount: gameSettings.playerCount, startingLife: gameSettings.startingLife)
//        for g in games {
//            context.delete(g)
//        }
        context.insert(game)
        gameSettings.game = game
        try? context.save()
    }
}

#Preview {
    PlayerCountSelection()
}
