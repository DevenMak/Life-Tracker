//
//  CommanderCounter.swift
//  Life Tracker
//
//  Created by Deven Mak on 7/31/26.
//

import SwiftUI

struct CommanderCounter: View {
    var size: CGSize
    var index: Int
    var playerVM = PlayerViewModel.shared
    @State var count: Int = 0
    var player: Player
    var otherPlayers: [Player] {
        playerVM.players.filter { $0.id != player.id }
    }
    var playerColor: Color {
        Color(otherPlayers[index].color ?? "Player1")
    }
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                playerVM.decreaseCD(player: player, cd: index+1)
            }) {
                UnevenRoundedRectangle(0, 0,0,0)
                    .fill(playerColor)
            }
            Button(action: {
                playerVM.increaseCD(player: player, cd: index+1)
            }) {
                UnevenRoundedRectangle(0,0,0,index == 0 ? size.width/15.0 : 0)
                    .fill(playerColor)
            }
        }
        .overlay(
            CommanderCounterText(color: playerColor, player: player, cd: index+1)
        )
        
    }
}

var counterHeightLimit: CGFloat = 60
var titleHeight: CGFloat = 30

struct CommanderCounterStack: View {
    var size: CGSize
    
    
    @StateObject var playerVM = PlayerViewModel.shared
    var player: Player
    var otherPlayers: [Player] {
        playerVM.players.filter { $0.id != player.id }
    }
    var counterHeight: CGFloat {
        max((size.width*frameMult*0.5-titleHeight)/CGFloat(otherPlayers.count), min((size.height-titleHeight)/CGFloat(otherPlayers.count), counterHeightLimit))
    }
    var body: some View {
        ZStack(alignment: .top) {
            UnevenRoundedRectangle(0,0,0,size.width/15.0)
                .fill(.white)
                .frame(width: size.width*frameMult*0.5, height: counterHeight*CGFloat(otherPlayers.count)+titleHeight)
            VStack(spacing: 0) {
                ForEach(0..<otherPlayers.count, id: \.self) { i in
                    CommanderCounter(size: size, index: i, player: player)
                        .frame(width: size.width*frameMult*0.5, height: counterHeight)
                }
                CommanderStackTitle(color: Color(otherPlayers.last!.color ?? "Player 1"))
                    .frame(width: size.width*frameMult*0.5, height: titleHeight)
                
            }
        }
        
    }
}



struct CommanderCounterText: View {
    @StateObject var playerVM = PlayerViewModel.shared
    var color: Color
    @ObservedObject var player: Player
    var cd: Int
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                Text("-")
                Spacer()
                Text("\(playerVM.getCD(player: player, cd: cd))")
                    .numberStyle(40)
                Spacer()
                Text("+")
                Spacer()
            }
        }
        .foregroundStyle(.white)
    }
}

struct CommanderStackTitle: View {
    var color: Color
    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
            HStack(spacing: 0) {
                Text("Commander ")
                    .small()
                    .padding(.trailing, 5)
                Image("commanderIcon")
                    .counterIconStyle()
            }
            .foregroundStyle(contrastTextColor(color))
        }
    }
}
//#Preview {
//    CommanderCounterStack(size: CGSize(width: 300, height: 300))
//}
