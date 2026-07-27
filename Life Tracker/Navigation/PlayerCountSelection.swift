//
//  PlayerCountSelection.swift
//  Life Tracker
//
//  Created by Deven Mak on 3/14/26.
//

import SwiftUI

let image = UIImage(systemName: "arrow.left")

let imageHeight = image!.size.height
let imageWidth = image!.size.width
let scale = 30.0/max(imageHeight, imageWidth)

struct PlayerCountSelection: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var backButtonPlacement: ToolbarItemPlacement {
         ToolbarItemPlacement.navigationBarLeading
     }
    var body: some View {
        @StateObject var path = Path.shared

        ZStack {
            Color.black.ignoresSafeArea()
            VStack() {
                Text("Players")
                    .heading()
                    .foregroundStyle(.white)
                    .padding()
                Spacer()
            }
            VStack {
                Button(action: {
                    GameViewModel.shared.addGame()
                    guard let game = GameViewModel.shared.currentGame else { return }
                    GameViewModel.shared.setPlayerCount(2)
                    InitialGameSettings.shared.playerCount = 2
                    PlayerViewModel.shared.setUp(game: game)
                    ValueViewModel.shared.setUp(game: game)

                    print(InitialGameSettings.shared.startingLife)
                    path.navPath.append(Route.game)
                }) {
                    PlayerButton(numPlayers: 2)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
             ToolbarItem(placement: backButtonPlacement) {
                 Button {
                     self.presentationMode.wrappedValue.dismiss()
                 } label: {
                     Image(systemName: "arrow.left")
                         .resizable()
                         .renderingMode(.template)
                         .frame(width: imageWidth*scale, height: imageHeight*scale)
                         .foregroundStyle(.white)
                 }
             }
         }
    }
}

#Preview {
    PlayerCountSelection()
}

struct PlayerButton: View {
    var numPlayers: Int
    
    let image = UIImage(named: "playerIcon")
    
    
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(1...numPlayers, id: \.self) { number in
                    
                    let imageHeight = image!.size.height
                    let imageWidth = image!.size.width
                    let scale = 50.0/max(imageHeight, imageWidth)
                    
                    Image("playerIcon")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(.red)
                        .opacity(1-Double((numPlayers-number))*0.2)
                        .frame(width: imageWidth*scale, height: imageHeight*scale)
                        .offset(x: 15*CGFloat(number-1),  y: 10*CGFloat(number-1))
                    
                    
                }
                .offset(x: CGFloat(-1*(7.5*Double(numPlayers-1))), y: CGFloat(-1*(5*Double(numPlayers-1))))
                
                
            }
            Text("\(numPlayers) Player")
                .font(
                    .custom(
                        "AvenirNextCondensed-Regular",
                        size: 40)
                    .weight(.medium)
                    
                )
                .foregroundStyle(.white)
                .opacity(0.65)
        }
    }
}
