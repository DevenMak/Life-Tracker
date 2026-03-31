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
                
                VStack {
                    Button("20") {
                        InitialGameSettings.shared.startingLife = 20
                        path.navPath.append(Route.playerSelection)
                    }
                    
                }
                
                VStack {
                    Button("40") {
                        InitialGameSettings.shared.startingLife = 40
                        path.navPath.append(Route.playerSelection)
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
                         .foregroundStyle(.white)
                 }
             }
         }
        
    }
}

#Preview {
    LifeSelection()
}
