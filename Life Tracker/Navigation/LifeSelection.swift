//
//  LifeSelection.swift
//  Life Tracker
//
//  Created by Deven Mak on 3/25/26.
//

import SwiftUI

struct LifeSelection: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var backButtonPlacement: ToolbarItemPlacement {
         ToolbarItemPlacement.navigationBarLeading
     }
    @StateObject var path = Path.shared
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("Life")
                    .heading()
                    .foregroundStyle(.white)
                    .padding()
                Spacer()
            }
            VStack(spacing: 90) {
                Button(action: {
                    InitialGameSettings.shared.startingLife = 20
                    InitialGameSettings.shared.commander = false
                    path.navPath.append(Route.playerSelection)
                }) {
                    ZStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 43))
                            .foregroundStyle(.accent)
                        Text("20")
                            .numberStyle(80)
                            .foregroundStyle(.white)
                            .opacity(0.65)
                    }
                }
                
                
                Button(action: {
                    InitialGameSettings.shared.startingLife = 40
                    InitialGameSettings.shared.commander = true
                    path.navPath.append(Route.playerSelection)
                }) {
                    ZStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 43))
                            .foregroundStyle(.accent)
                        Text("40")
                            .numberStyle(80)
                            .foregroundStyle(.white)
                            .opacity(0.65)
                    }
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
                         .foregroundStyle(.accent)
                 }
             }
         }
        
    }
}

#Preview {
    LifeSelection()
}
