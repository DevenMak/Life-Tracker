//
//  TallyView.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/15/26.
//

import SwiftUI
import SwiftData

struct TallyView: View {
    @Environment(\.modelContext) private var context
    var player: Player
    var tallySize: CGFloat?
    var tallyName: String
    var tally: Tally {
        player.tallies.first(where: {
            $0.name == tallyName
        })!
    }
    
    var body: some View {
        let tallyColor = Color("\(tally.name)Color")
        ZStack {
            UnevenRoundedRectangle(30,30,30,30)
                .fill(.white)
                .frame(width: multiplyTallySize(by: 2), height: multiplyTallySize(by: 2))
            VStack(spacing: 0) {
                Button(action: {
                    if tally.value < 99 {
                        tally.value += 1
                        try? context.save()
                    }
                }) {
                    UnevenRoundedRectangle(30,0,0,30)
                        .fill(tallyColor)
                        .frame(width: multiplyTallySize(by: 2), height: multiplyTallySize(by: 0.5))
                }
                
                Button(action: {
                    if tally.value > 0 {
                        tally.value -= 1
                        try? context.save()
                    }
                }) {
                    Rectangle()
                        .fill(tallyColor)
                        .frame(width: multiplyTallySize(by: 2), height: multiplyTallySize(by: 0.5))
                }
                Button(action: {
                    if tally.value < 99 {
                        tally.value += 1
                        try? context.save()
                    }
                }) {
                    Rectangle()
                        .fill(tallyColor)
                        .frame(width: multiplyTallySize(by: 2), height: multiplyTallySize(by: 0.5))
                }
                Button(action: {
                    if tally.value > 0 {
                        tally.value -= 1
                        try? context.save()
                    }
                }) {
                    UnevenRoundedRectangle(0,30,30,0)
                        .fill(tallyColor)
                        .frame(width: multiplyTallySize(by: 2), height: multiplyTallySize(by: 0.5))
                }
            }
            .overlay(
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        TallyText(tally: tally, tallySize: tallySize)
                        TallyText(tally: tally, tallySize: tallySize)
                    }
                    HStack(spacing: 0) {
                        TallyText(tally: tally, tallySize: tallySize)
                        TallyText(tally: tally, tallySize: tallySize)
                    }
                }
            )
        }
    }
    func multiplyTallySize(by a: CGFloat) -> CGFloat? {
        return tallySize.map { $0 * a }
    }
}

struct TallyText: View {
    var tally: Tally
    var tallySize: CGFloat?
    var body: some View {
        VStack(spacing: 0) {
//            Image(systemName: "plus")
//                .font(.system(size: 15, weight: .bold))
//                .padding(.top, 10)

            Spacer()
            HStack {
                Text("\(tally.value)")
                    .rubikMedium(25)
                Image("\(tally.name)Icon")
                    .iconSize(20)
            }
            Spacer()
//            Image(systemName: "minus")
//                .font(.system(size: 15, weight: .bold))
//                .padding(.bottom, 10)
        }
        .frame(maxWidth: tallySize, maxHeight: tallySize)
        .foregroundStyle(contrastTextColor(Color("\(tally.name)Color")))
        .allowsHitTesting(false)
    }
}



#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Game.self, configurations: config)

    let game = Game(playerCount: 2, startingLife: 40 )
    container.mainContext.insert(game)
    return TallyView(player: game.players[0], tallySize: 60, tallyName: "poison")
        .modelContainer(container)
}
