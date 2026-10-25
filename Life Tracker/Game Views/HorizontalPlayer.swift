//
//  HorizontalPlayer.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/21/26.
//

import SwiftUI
import SwiftData

struct HorizontalPlayer: View {
    var player: Player
    var cornerRadii: [CGFloat] = [0,0,0,0]
    var playerTallies: [Tally] {
        player.tallies
    }
    var body: some View {
        GeometryReader { geo in
            ZStack {
                HStack(spacing: 0) {
                    Button(action: {
                        player.life -= 1
                    }) {
                        UnevenRoundedRectangle(cornerRadii[0], cornerRadii[1], 0, 0)
                            .fill(Color("Player2.\(player.order)"))
                    }
                    Button(action: {
                        player.life += 1
                    }) {
                        UnevenRoundedRectangle(0, 0, cornerRadii[2], cornerRadii[3])
                            .fill(Color("Player2.\(player.order)"))
                    }
                    
                }
                .overlay(
                    HorizontalPlayerText(player: player)
                )
                
                let tallySize: CGFloat = geo.size.height/3.5
                if let showingTally = playerTallies.first(where: {$0.order == 1}) {
                    if showingTally.name == "commander" {
                        CommanderTally(player: player, tallySize: tallySize)
                            .rotationEffect(.degrees(90))
                            .position(x: 0, y: 0)
                            .transition(ZoomTransition(size: tallySize*2, x: 0, y: 0))
                            .zIndex(1)
                    } else {
                        TallyView(player: player, tallySize: tallySize, tallyName: showingTally.name)
                            .rotationEffect(.degrees(90))
                            .position(x: 0, y: 0)
                            .transition(ZoomTransition(size: tallySize*2, x: 0, y: 0))
                            .zIndex(1)
                    }
                }
                
                if let showingTally = playerTallies.first(where: {$0.order == 2}) {
                    TallyView(player: player, tallySize: tallySize, tallyName: showingTally.name)
                        .rotationEffect(.degrees(90))
                        .position(x: 0, y: geo.size.height)
                        .transition(ZoomTransition(size: tallySize*2, x: 0, y: geo.size.height))
                        .zIndex(1)
                }
            }
        }
    }
    
}

struct HorizontalPlayerText: View {
    @State var size: CGSize = .zero
    var player: Player
    var body: some View {
        ZStack {
            HStack {
                Image(systemName: "minus")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.leading, 10)
                    .rotationEffect(.degrees(90))
                Spacer()
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .bold))
                    .padding(.trailing, 10)
            }
            scoreLabel
                .background(
                    scoreLabel
                        .onGeometryChange(for: CGSize.self) { return $0.size } action: { size = $0 }
                        .opacity(0)
                )
                .fixedSize()
                .rotationEffect(.degrees(90))
                .frame(width: size.height, height: size.width)
        }
        .foregroundStyle(.white)
    }
    
    var scoreLabel: some View {
        HStack {
            Text("\(player.life)")
                .rubikMedium(55)
            Image("heartIcon")
                .iconSize()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Game.self, configurations: config)

    let game = Game(playerCount: 2, startingLife: 0 )
    game.players[0].tallies[0].order = 1
    container.mainContext.insert(game)
    return HorizontalPlayer(player: game.players[0], cornerRadii: [0,0,0,30])
        .modelContainer(container)
}
