//
//  ContentView.swift
//  Life Tracker
//
//  Created by Deven Mak on 2/20/26.
//

import SwiftUI

class InitialGameSettings: ObservableObject {
    public static var shared = InitialGameSettings()
    @Published var startingLife: Int = 0
    @Published var playerCount: Int = 0
    @Published var newGame = true
}

class Path: ObservableObject {
    public static var shared = Path()
    @Published var navPath = NavigationPath()
}
enum Route: Hashable {
    case game
    case playerSelection
    case lifeSelection
    case savedGames
}

struct ContentView: View {
    @StateObject var path = Path.shared
    @StateObject var gameVM = GameViewModel.shared
    var body: some View {
        NavigationStack(path: $path.navPath) {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack {
                    Text("Game")
                        .heading()
                        .foregroundStyle(.white)
                    
                    VStack {
                        Button("New Game") {
                            InitialGameSettings.shared.newGame = true
                            gameVM.addGame()
                            path.navPath.append(Route.lifeSelection)
                        }
                        
                    }
                    
                    VStack {
                        Button("Saved Game") {
                            path.navPath.append(Route.savedGames)
                        }
                        
                    }
                }
                
                
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .game:
                    GameView()
                case .playerSelection:
                    PlayerCountSelection()
                case .lifeSelection:
                    LifeSelection()
                case .savedGames:
                    SavedGames()
                }
            }

            
        }
        .statusBarHidden(true)

        
    }
}

#Preview {
    ContentView()
}
