//
//  ContentView.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/13/26.
//

import SwiftUI
import SwiftData


enum Route: Hashable {
    case twoPlayerView
    case fourPlayerView
    case playerCountSelection
    case lifeSelection
    case savedGames
    case fourPlayerPlusView
    case threePlayerYView
    case threePlayerZView
    case layoutSelection
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
                    Button(action: {
                        GameSettings.shared.startingLife = 20
                        path.navPath.append(Route.lifeSelection)
                    }) {
                        Text("Start New Game")
                            .avenir(25)
                            .foregroundStyle(Color.accent)
                            .padding()
                            .background(.black)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.accent, lineWidth: 2)
                                
                            )
                            .padding(60)
                        
                    }
                    Button(action: {
                        path.navPath.append(Route.savedGames)
                    }) {
                        Text("Continue Game")
                            .avenir(25)
                            .foregroundStyle(Color.accent)
                            .padding()
                            .background(.black)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.accent, lineWidth: 2)
                                
                            )
                            .padding(60)
                    }
                    Spacer()
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .fourPlayerView:
                    FourPlayerView(game: GameSettings.shared.game!)
                case .twoPlayerView:
                    TwoPlayerView(game: GameSettings.shared.game!)
                case .fourPlayerPlusView:
                    FourPlayerViewPlus(game: GameSettings.shared.game!)
                case .threePlayerYView:
                    ThreePlayerViewY(game: GameSettings.shared.game!)
                case .threePlayerZView:
                    ThreePlayerViewZ(game: GameSettings.shared.game!)
                case .playerCountSelection:
                    PlayerCountSelection()
                case .savedGames:
                    SavedGames()
                case .layoutSelection:
                    LayoutSelection()
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
