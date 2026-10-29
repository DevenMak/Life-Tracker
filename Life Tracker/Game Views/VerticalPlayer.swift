//
//  VerticalPlayer.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/13/26.
//

import SwiftUI
import SwiftData

let cornerRad: CGFloat = 10

struct VerticalPlayer: View {
    @Environment(\.modelContext) private var context
    var player: Player
    var tallySize: CGFloat?
    @State var showTally: Bool = false
    @Query private var allTallies: [Tally]
    var playerTallies: [Tally] {
        allTallies
            .filter {$0.player == player}
    }
    var totalTallySize: CGFloat? { tallySize.map {$0 * 2} }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                UnevenRoundedRectangle(cornerRad,0,0,cornerRad)
                    .fill(.white)
                VStack(spacing: -0.5) {
                    //Add Life Button
                    Button(action: {
                        player.life += 1
                        try? context.save()
                    }) {
                        UnevenRoundedRectangle(cornerRad,0,0,cornerRad)
                            .fill(Color("Player2.\(player.order)"))
                    }
                    Button(action: {
                        player.life -= 1
                        try? context.save()
                    }) {
                        UnevenRoundedRectangle(0,0,0,0)
                            .fill(Color("Player2.\(player.order)"))
                    }
                }
                  
                if let showingTally = playerTallies.first(where: {$0.order == 1}) {
                    if showingTally.name == "commander" {
                        CommanderTally(player: player, tallySize: tallySize)
                            .position(x: 0, y: geo.size.height)
                            .transition(ZoomTransition(size: totalTallySize, x: 0, y: geo.size.height))
                            .zIndex(1)
                    } else {
                        TallyView(player: player, tallySize: tallySize, tallyName: showingTally.name)
                            .position(x: 0, y: geo.size.height)
                            .transition(ZoomTransition(size: totalTallySize, x: 0, y: geo.size.height))
                            .zIndex(1)
                    }
                }
                
                if let showingTally = playerTallies.first(where: {$0.order == 2}) {
                    TallyView(player: player, tallySize: tallySize, tallyName: showingTally.name)
                        .position(x: geo.size.width, y: geo.size.height)
                        .transition(ZoomTransition(size: totalTallySize, x: geo.size.width, y: geo.size.height))
                        .zIndex(1)
                }
                
                
                text
                
            }
            .reportMinSize(computedBy: { size in
                size.width / 3
            })
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

    let game = Game(playerCount: 2, startingLife: 40)
    game.players[0].tallies[0].order = 1
    container.mainContext.insert(game)
    return VerticalPlayer(player: game.players[0])
        .modelContainer(container)
}
