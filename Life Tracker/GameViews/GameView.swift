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
            for i in 0..<InitialGameSettings.shared.playerCount {
                addPlayer(i, InitialGameSettings.shared.startingLife)
            }
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
    
    func addPlayer(_ number: Int, _ life: Int) {

        for player in players {
            if player.number == Int16(number) {
                return
            }
        }
        let player = Player(context: manager.context)
        player.number = Int16(number)
        player.life = Int16(life)
        player.game = game
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
    
    func save() {
        manager.save()
        fetchPlayers()
    }
}

struct GameView: View {
    @State var menuOpen: Bool = false
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ZStack {
                    Color.black.ignoresSafeArea()
                    
                    VStack(spacing: 7) {
                        PlayerView(player: PlayerViewModel.shared.players[0])
                            .rotationEffect(.degrees(180))
                        PlayerView(player: PlayerViewModel.shared.players[1])
                        
                    }
                    
                    .ignoresSafeArea()
                    
                    
                    Circle()
                        .fill(Color.white)
                        .stroke(.black, lineWidth: 7)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "circle.grid.3x3.fill")
                                .renderingMode(.template)
                                .foregroundStyle(.black)
                        )
                        .offset(y: -0.5*(geo.safeAreaInsets.top-geo.safeAreaInsets.bottom))
                        .onTapGesture {
                            withAnimation {
                                menuOpen = true
                            }
                        }
                    
                }
                .compositingGroup()
                .blur(radius: menuOpen ? 5 : 0)

                Color.black.ignoresSafeArea(edges: .all)
                    .opacity(menuOpen ? 0.9 : 0)
                

                Menu(showMenu: $menuOpen)
                    .opacity(menuOpen ? 1 : 0)
                    
            }
            .onAppear {
                if InitialGameSettings.shared.newGame {
                    for player in PlayerViewModel.shared.players {
                        PlayerViewModel.shared.setLife(player, InitialGameSettings.shared.startingLife)
                    }
                }
                
                print(GameViewModel.shared.savedGames.count)
            }
        }
        .navigationBarBackButtonHidden()

        .ignoresSafeArea()
    }
}

#Preview {
    GameView()
}
