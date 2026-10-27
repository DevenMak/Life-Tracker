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
    @Published var commander: Bool = false
    @Published var game: Game?
}

struct PlayerCountSelection: View {
    @StateObject var gameSettings: GameSettings = .shared
    @Environment(\.modelContext) private var context
    @Query private var games: [Game]
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("Player Count")
                    .heading()
                    .foregroundStyle(.white)
                    .padding(50)
                Button(action: {
                    gameSettings.playerCount = 2
                    startNewGame()
                    Path.shared.navPath.append(Route.twoPlayerView)
                }) {
                    PlayerButton(numPlayers: 2)
                }
                .padding(40)
                
                Button(action: {
                    gameSettings.playerCount = 4
                    startNewGame()
                    Path.shared.navPath.append(Route.fourPlayerView)
                }) {
                    PlayerButton(numPlayers: 4)
                }
                .padding(40)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
             CustomBackButton()
        }

    }
    
    func startNewGame() {
        let game = Game(playerCount: gameSettings.playerCount, startingLife: gameSettings.startingLife, commander: gameSettings.commander)
        context.insert(game)
        gameSettings.game = game
        try? context.save()
    }
}

struct CustomBackButton: ToolbarContent {
    static let arrowImage = UIImage(systemName: "arrow.left")

    static let arrowHeight = arrowImage!.size.height
    static let arrowWidth = arrowImage!.size.width
    static let arrowScale = 30.0/max(arrowHeight, arrowWidth)
    var body: some ToolbarContent {
        ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
            Button {
                Path.shared.navPath.removeLast()
            } label: {
                Image(systemName: "arrow.left")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: CustomBackButton.arrowWidth*CustomBackButton.arrowScale,
                           height: CustomBackButton.arrowHeight*CustomBackButton.arrowScale)
                    .foregroundStyle(.accent)
            }
        }
    }
}

struct PlayerButton: View {
    var numPlayers: Int
    
    let image = UIImage(named: "playerIcon")
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(1...numPlayers, id: \.self) { number in
                    
                    let imageHeight = image!.size.height
                    let imageWidth = image!.size.width
                    let scale = 50.0/max(imageHeight, imageWidth)
                    
                    Image("playerIcon")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(.red)
                        .opacity(1-Double((numPlayers-number))*0.2)
                        .frame(width: imageWidth*scale, height: imageHeight*scale)
                        .offset(x: 15*CGFloat(number-1),  y: 10*CGFloat(number-1))
                    
                    
                }
                .offset(x: CGFloat(-1*(7.5*Double(numPlayers-1))), y: CGFloat(-1*(5*Double(numPlayers-1))))
                
                
            }
            Text("\(numPlayers) Player")
                .avenir(40)
                .foregroundStyle(.white)
                .opacity(0.65)
        }
    }
}

#Preview {
    PlayerCountSelection()
}
