//
//  SavedGames.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/15/26.
//

import SwiftUI
import SwiftData
struct SavedGames: View {
    @Query private var games: [Game]
    var body: some View {
        List {
            ForEach(games) { game in
                Button(action: {
                    GameSettings.shared.game = game
                    Path.shared.navPath.append(Route.twoPlayerView)
                }) {
                    Text("\(game.date)")
                }
            }
        }
    }
}

#Preview {
    SavedGames()
}
