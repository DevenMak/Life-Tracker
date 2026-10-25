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
    case fourPlayerView
    case playerCountSelection
    case lifeSelection
    case savedGames
}

struct ContentView: View {
    @StateObject var path = Path.shared
    @Environment(\.modelContext) private var context
    @Query private var games: [Game]
    @Query private var tallies: [Tally]
    var body: some View {
        NavigationStack(path: $path.navPath) {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    Text("Life Tracker")
                        .heading()
                        .foregroundStyle(.white)
                        .padding()
                    Spacer()
                }
                VStack(spacing: 100) {
                    Button(action: {
                        GameSettings.shared.startingLife = 20
                        path.navPath.append(Route.lifeSelection)
                    }) {
                        Text("Go to life selection")
                    }
                    Button(action: {
                        path.navPath.append(Route.savedGames)
                    }) {
                        Text("Go to saved games")
                    }
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .fourPlayerView:
                    FourPlayerView(game: GameSettings.shared.game!)
                case .twoPlayerView:
                    TwoPlayerView(game: GameSettings.shared.game!)
                case .playerCountSelection:
                    PlayerCountSelection()
                case .savedGames:
                    SavedGames()
                case .lifeSelection:
                    LifeSelection()
                
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
