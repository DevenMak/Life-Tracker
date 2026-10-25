//
//  CommanderTally.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/20/26.
//

import SwiftUI
import SwiftData

struct CommanderTally: View {
    var player: Player
    var tallySize: CGFloat

    var playerCount: Int {
        guard let game = player.game else { return 0 }
        return game.players.count
    } 
    
    var otherPlayers: [Player] {
        guard let game = player.game else { return [] }
        return game.players
            .filter { $0 != player }
            .sorted { $0.order < $1.order }
    }
    var body: some View {
        ZStack(alignment: .topTrailing) {
            UnevenRoundedRectangle(0,0,0,30)
                .fill(.white)
                .frame(width: tallySize * 2, height: tallySize * 2)
            ZStack {
                HStack(spacing: -1) {
                    ForEach(otherPlayers) { p in
                        VStack(spacing: -1) {
                            Button(action: {
                                player.comDamages[p.order] += 1
                            }) {
                                UnevenRoundedRectangle(0,0,0, p == otherPlayers.last ? 30 : 0)
                                    .fill(Color("Player2.\(p.order)"))
                                
                                
                            }
                            Button(action: {
                                player.comDamages[p.order] -= 1
                            }) {
                                Rectangle()
                                    .fill(Color("Player2.\(p.order)"))
                            }
                        }
                        .overlay(
                            Text("\(player.comDamages[p.order])")
                                .rubikMedium(20)
                                .foregroundStyle(.white)
                                .allowsHitTesting(false)
                        )
                    }
                }
//                VStack(spacing: 0) {
//                    Image(systemName: "plus")
//                        .font(.system(size: 10, weight: .bold))
//                        .padding(.top, 5)
//                    
//                    Spacer()
//                    Image(systemName: "minus")
//                        .font(.system(size: 10, weight: .bold))
//                        .padding(.bottom, 5)
//                }
//                .foregroundStyle(.white)
//                .allowsHitTesting(false)
                
                VStack {
                    Spacer()
                    HStack {
                        Text("Commander")
                            .avenirMedium(10)
                        Image("commanderIcon")
                            .iconSize(15)
                    }
                    .padding(.bottom, 10)
                    .frame(maxWidth: tallySize)
                }
                .foregroundStyle(.white)
            }
            .frame(width: tallySize, height: tallySize)
        }
    }
    
}

struct CommanderText: View {
    var player: Player
    var order: Int
    var tallySize: CGFloat
    var body: some View {
        VStack {
            Spacer()
            Text("\(player.comDamages[order])")
                .rubikMedium(20)
            Spacer()
        }
        .foregroundStyle(contrastTextColor(Color("Player2.\(1)")))
        .allowsHitTesting(false)
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Game.self, configurations: config)

    let game = Game(playerCount: 4, startingLife: 40 )
    container.mainContext.insert(game)
    return CommanderTally(player: game.players[0], tallySize: 100)
        .modelContainer(container)
        .frame(width: 100, height: 100)
}
