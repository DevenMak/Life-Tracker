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
    @State var showTally: Bool = false
    @Query private var allTallies: [Tally]
    var tallies: [Tally] {
        allTallies
            .filter {$0.player == player}
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                UnevenRoundedRectangle(cornerRad,0,0,cornerRad)
                    .fill(.white)
                VStack(spacing: -0.5) {
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
                let tallySize: CGFloat = geo.size.width/3.5
                
                
                    
                if let showingTally = tallies.first(where: {$0.order == 1}) {
                    TallyView(player: player, tallySize: tallySize, tallyName: showingTally.name)
                        .position(x: 0, y: geo.size.height)
                        .transition(ZoomTransition(size: tallySize*2, x: 0, y: geo.size.height))
                        .zIndex(1)
                }
                
                if let showingTally = tallies.first(where: {$0.order == 2}) {
                    TallyView(player: player, tallySize: tallySize, tallyName: showingTally.name)
                        .position(x: geo.size.width, y: geo.size.height)
                        .transition(ZoomTransition(size: tallySize*2, x: geo.size.width, y: geo.size.height))
                        .zIndex(1)
                }
                
                text
            }
            .compositingGroup()

        }
        .compositingGroup()



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
    container.mainContext.insert(game)
    return VerticalPlayer(player: game.players[0])
        .modelContainer(container)
}
