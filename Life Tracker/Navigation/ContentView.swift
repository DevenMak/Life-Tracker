//
//  ContentView.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/13/26.
//

import SwiftUI
import SwiftData

class Path: ObservableObject {
    public static var shared = Path()
    @Published var navPath = NavigationPath()
}
enum Route: Hashable {
    case twoPlayerView
    case playerCountSelection
    case savedGames
}

struct ContentView: View {
    @StateObject var path = Path.shared
    @Environment(\.modelContext) private var context
    @Query private var games: [Game]
    @Query private var tallies: [Tally]
    var body: some View {
        NavigationStack(path: $path.navPath) {
            VStack {
                Button(action: {
                    GameSettings.shared.startingLife = 20
                    path.navPath.append(Route.playerCountSelection)
                }) {
                    Text("Go to player selection")
                }
                Button(action: {
                    path.navPath.append(Route.savedGames)
                }) {
                    Text("Go to saved games")
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .twoPlayerView:
                    TwoPlayerView(game: GameSettings.shared.game!)
                case .playerCountSelection:
                    PlayerCountSelection()
                case .savedGames:
                    SavedGames()
                
                }
            }
           
        }
        .statusBarHidden(true)

    }
    
    func deleteGame(game: Game) {
        context.delete(game)
        try? context.save()
    }
    
    
}

#Preview {
    ContentView()
}
