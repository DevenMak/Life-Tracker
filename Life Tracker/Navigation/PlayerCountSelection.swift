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
            VStack {
                Button("2 Players") {
                    InitialGameSettings.shared.playerCount = 2
                    PlayerViewModel.shared.setUp(game: GameViewModel.shared.savedGames.last!)
                    ValueViewModel.shared.setUp(game: GameViewModel.shared.savedGames.last!)

                    print(InitialGameSettings.shared.startingLife)
                    path.navPath.append(Route.game)
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

//#Preview {
//    PlayerCountSelection()
//}
