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
    @State var count: Int = 0
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
                        count += 1
                        try? context.save()
                    }) {
                        UnevenRoundedRectangle(cornerRad,0,0,cornerRad)
                            .fill(Color("Player2.\(player.order)"))
                    }
                    Button(action: {
                        player.life -= 1
                        count -= 1
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
                
                ActiveCounter(count: $count)
                    .offset(x: 0, y: -70)
                
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

struct ActiveCounter: View {
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    @State var reloadTime = 1.0
    @State var timeRemaining = 0.0
    @State var refreshable: Bool = true
    @Binding var count: Int
    var body: some View {
        Text("\(count > 0 ? "+" : count == 0 ? "" : "-")\(abs(count))")
            .rubik(25)
            .foregroundStyle(.white)
            .scaleEffect(1.25*(max(1-(reloadTime-timeRemaining)/reloadTime, 0.6)))
            .opacity(timeRemaining/reloadTime*1.7)
            .onReceive(timer) { _ in
                if(timeRemaining > 0) {
                    timeRemaining -= 0.01
                }
                if(timeRemaining <= 0 && count != 0) {
                    refreshable = false
                    count = 0
                    timeRemaining = 0
                }
            }
            .offset(x: 75)
            .onChange(of: count) { oldValue, newValue in
                if refreshable {
                    timeRemaining = reloadTime
                }
                refreshable = true
            }
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
