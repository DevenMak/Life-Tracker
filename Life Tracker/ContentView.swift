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
    case menu
    case twoPlayerView
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
                    startNewGame()
                    path.navPath.append(Route.menu)
                }) {
                    Text("Go to Menu")
                }
                Button(action: {
                    startNewGame()
                    path.navPath.append(Route.twoPlayerView)
                }) {
                    Text("Go to 2 Player")
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .menu:
                    Menu(game: games[0])
                case .twoPlayerView:
                    TwoPlayerView(game: games[0])
                
                }
            }
           
        }
        
    }
    
    func deleteGame(game: Game) {
        context.delete(game)
        try? context.save()
    }
    
    func startNewGame() {
        let game = Game(playerCount: 2, startingLife: 20)
        for g in games {
            deleteGame(game: g)
        }
        context.insert(game)
        try? context.save()
    }
}

#Preview {
    ContentView()
}
