//
//  GameView.swift
//  Life Tracker
//
//  Created by Deven Mak on 3/14/26.
//

import SwiftUI
import CoreData

class PlayerViewModel: ObservableObject {
    let manager = CoreDataManager.instance
    public static var shared = PlayerViewModel()
    @Published var players: [Player] = []
    var game: Game?
    
    func getPlayersForGame() {
        if let gamePlayers = self.game?.players?.allObjects as? [Player] {
            players = gamePlayers
        }
    }
    
    func setUp(game: Game) {
        self.game = game
        if InitialGameSettings.shared.newGame {
            self.players = []
            //add players
            for i in 1...InitialGameSettings.shared.playerCount {
                addPlayer(InitialGameSettings.shared.startingLife, "Player2.\(i)")
            }
            self.game!.commander = InitialGameSettings.shared.commander
        }
        save()
    }
    
    func fetchPlayers() {
        let request = NSFetchRequest<Player>(entityName: "Player")
        
        do {
            players = try manager.context.fetch(request)
            getPlayersForGame()
        } catch let error {
            print(error)
        }
    }
    
    func addPlayer(_ life: Int, _ color: String) {

        let player = Player(context: manager.context)
        player.life = Int16(life)
        player.color = color
        player.game = game
        player.cd1 = 0
        player.cd2 = 0
        player.cd3 = 0
        save()

    }
    
    func addLife(_ player: Player) {
        player.life += 1
        save()
    }
    
    func loseLife(_ player: Player) {
        player.life-=1
        save()
    }
    
    func setLife(_ player: Player, _ amt: Int) {
        player.life = Int16(amt)
        save()
    }
    
    func increaseCD(player: Player, cd: Int) {
        switch cd {
        case 1: player.cd1 += 1
        case 2: player.cd2 += 1
        case 3: player.cd3 += 1
        default: break
        }
    }
    
    func decreaseCD(player: Player, cd: Int) {
        switch cd {
        case 1: player.cd1 -= 1
        case 2: player.cd2 -= 1
        case 3: player.cd3 -= 1
        default: break
        }
    }
    
    func getCD(player: Player, cd: Int) -> Int {
        switch cd {
        case 1: return Int(player.cd1)
        case 2: return Int(player.cd2)
        case 3: return Int(player.cd3)
        default: return 0
        }
    }
    
    func save() {
        manager.save()
        fetchPlayers()
    }
}

let spacingBetweenPlayerViews: CGFloat = 7
struct TwoPlayerGame: View {
    @State var menuOpen: Bool = false
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ZStack {
                    Color.black.ignoresSafeArea()
                    
                    VStack(spacing: spacingBetweenPlayerViews) {
                        PlayerView(player: PlayerViewModel.shared.players[0])
                            .rotationEffect(.degrees(180))
                        PlayerView(player: PlayerViewModel.shared.players[1])
                        
                    }
                    
                    .ignoresSafeArea()
                    
                    
                    Button(action: {
                        withAnimation {
                            menuOpen = true
                        }
                    }) {
                        Circle()
                            .fill(Color.white)
                            .stroke(.black, lineWidth: spacingBetweenPlayerViews)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "circle.grid.3x3.fill")
                                    .renderingMode(.template)
                                    .foregroundStyle(.black)
                            )
                            .offset(y: -0.5*(geo.safeAreaInsets.top-geo.safeAreaInsets.bottom))
                    }
                    .buttonStyle(.expanding)
                    
                }
                .compositingGroup()
                .blur(radius: menuOpen ? 5 : 0)

                Color.black.ignoresSafeArea(edges: .all)
                    .opacity(menuOpen ? 0.85 : 0)
                

                Menu(showMenu: $menuOpen)
                    .opacity(menuOpen ? 1 : 0)
                    
            }
        }
        .navigationBarBackButtonHidden()

        .ignoresSafeArea()
    }
}

#Preview {
    TwoPlayerGame()
}
