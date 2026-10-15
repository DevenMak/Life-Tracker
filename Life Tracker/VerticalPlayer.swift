//
//  VerticalPlayer.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/13/26.
//

import SwiftUI
import SwiftData

class VerticalPlayerViewModel {
    static public var shared = VerticalPlayerViewModel()
    
    public func addLife(_ player: Player, _ n: Int) {
        player.life += n
    }
}

let cornerRad: CGFloat = 10

struct VerticalPlayer: View {
    @Environment(\.modelContext) private var context
    var viewModel = VerticalPlayerViewModel.shared
    var player: Player

    @Query private var allTallies: [Tally]
    var tallies: [Tally] {
        allTallies
            .filter {$0.player == player}
            .sorted {$0.order < $1.order}
    }
    
    var body: some View {
        ZStack {
            UnevenRoundedRectangle(cornerRad,0,0,cornerRad)
                .fill(.white)
            VStack(spacing: 0) {
                //Add Life Button
                Button(action: {
                    viewModel.addLife(player, 1)
                    try? context.save()
                }) {
                    UnevenRoundedRectangle(cornerRad,0,0,cornerRad)
                        .fill(Color("Player2.\(player.order)"))
                }
                Button(action: {
                    viewModel.addLife(player, -1)
                    try? context.save()
                }) {
                    UnevenRoundedRectangle(0,0,0,0)
                        .fill(Color("Player2.\(player.order)"))
                }
            }
            
            text
        }


    }
    
    var text: some View {
        ZStack {
            VStack {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.top, 40)
                Spacer()
                Image(systemName: "minus")
                    .font(.system(size: 20, weight: .bold))
                    .padding()
            }
            VStack(spacing: 0) {
                Text("\(player.life)")
                    .rubikMedium(55)
                Image("heartIcon")
                    .iconSize()
            }
            
        }
        .foregroundStyle(.white)
        .allowsHitTesting(false)
    }
    
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Game.self, configurations: config)

    let game = Game(playerCount: 2, startingLife: 40 )
    return VerticalPlayer(player: game.players[0])
        .modelContainer(container)
}
