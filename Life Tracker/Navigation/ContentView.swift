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
    @Published var commander = false
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
                    Text("Life Tracker")
                        .heading()
                        .foregroundStyle(.white)
                        .padding()
                    
                    Spacer()
                }
                    
                VStack(spacing: 90) {
                    Button(action: {
                        InitialGameSettings.shared.newGame = true
                        path.navPath.append(Route.lifeSelection)
                    }) {
                        Text("New Game")
                            .avenir(25)
                            .foregroundStyle(Color.accent)
                            .padding()
                            .background(.black)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.accent, lineWidth: 2)
                                
                            )
                    }
                    
                    Button(action: {
                        path.navPath.append(Route.savedGames)
                    }) {
                        Text("Saved Game")
                            .avenir(25)
                            .foregroundStyle(Color.accent)
                            .padding()
                            .background(.black)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.accent, lineWidth: 2)
                                
                            )
                    }
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .game:
                    let playerCount = GameViewModel.shared.currentGame!.playerCount
                    if playerCount == 2 {
                        TwoPlayerGame()
                    } else if playerCount == 4 {
                        FourPlayerGame()
                    }
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
