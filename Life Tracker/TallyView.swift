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
    var tallySize: CGFloat
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
                .frame(width: tallySize*2, height: tallySize*2)
            VStack(spacing: 0) {
                Button(action: {
                    tally.value += 1
                    try? context.save()
                }) {
                    UnevenRoundedRectangle(30,0,0,30)
                        .fill(tallyColor)
                        .frame(width: tallySize*2, height: tallySize/2)
                }
                
                Button(action: {
                    tally.value -= 1
                    try? context.save()
                }) {
                    Rectangle()
                        .fill(tallyColor)
                        .frame(width: tallySize*2, height: tallySize/2)
                }
                Button(action: {
                    tally.value += 1
                    try? context.save()
                }) {
                    Rectangle()
                        .fill(tallyColor)
                        .frame(width: tallySize*2, height: tallySize/2)
                }
                Button(action: {
                    tally.value -= 1
                    try? context.save()
                }) {
                    UnevenRoundedRectangle(0,30,30,0)
                        .fill(tallyColor)
                        .frame(width: tallySize*2, height: tallySize/2)
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
}

struct TallyText: View {
    var tally: Tally
    var tallySize: CGFloat
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "plus")
                .font(.system(size: 15, weight: .bold))
                .padding(.top, 10)

            Spacer()
            HStack {
                Text("\(tally.value)")
                    .rubikMedium(20)
                Image("\(tally.name)Icon")
                    .iconSize(15)
            }
            Spacer()
            Image(systemName: "minus")
                .font(.system(size: 15, weight: .bold))
                .padding(.bottom, 10)
        }
        .frame(maxWidth: tallySize, maxHeight: tallySize)
        .foregroundStyle(contrastTextColor(Color("\(tally.name)Color")))
        .allowsHitTesting(false)
    }
}

struct ZoomTransition: Transition {
    var size: CGFloat
    var x: CGFloat
    var y: CGFloat

    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .mask {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: size, height: size)
                    .scaleEffect(phase.isIdentity ? 1 : 0)
                    .position(x: x, y: y)
            }
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
