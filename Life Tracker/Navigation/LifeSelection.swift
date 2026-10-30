//
//  LifeSelection.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/20/26.
//

import SwiftUI

struct LifeSelection: View {
    @State var showKeypad = false
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if showKeypad {
                Color.black.ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.35)) { showKeypad = false }
                    }
                    .zIndex(1)
                Keypad(showKeypad: $showKeypad)
                    .transition(KeypadTransition())
                    .zIndex(1)
            }
            
            VStack {
                Text("Life Selection")
                    .heading()
                    .foregroundStyle(.white)
                    .padding()
                
                buttons
                    .opacity(0)
                
                Spacer()
            }
            .zIndex(2)
            .ignoresSafeArea(edges: .bottom)
            
            VStack {
                Text("Life Selection")
                    .heading()
                    .foregroundStyle(.white)
                    .padding()
                    .opacity(0)
                
                buttons
                
                Spacer()
            }
            .ignoresSafeArea(edges: .bottom)
            
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            CustomBackButton()
        }
    }
    
    var buttons: some View {
        VStack {
            //20 Button
            Button(action: {
                GameSettings.shared.startingLife = 20
                GameSettings.shared.commander = false
                Path.shared.navPath.append(Route.playerCountSelection)
            }) {
                VStack {
                    ZStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 43))
                            .foregroundStyle(.accent)
                        Text("20")
                            .rubikMedium(80)
                            .foregroundStyle(.white)
                            .opacity(0.65)
                    }
                    Text("Standard")
                        .avenir(30)
                        .foregroundStyle(.white)
                }
            }
            .padding(30)
            //40 Button
            Button(action: {
                GameSettings.shared.startingLife = 40
                GameSettings.shared.commander = true
                Path.shared.navPath.append(Route.playerCountSelection)
            }) {
                VStack {
                    ZStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 43))
                            .foregroundStyle(.accent)
                        Text("40")
                            .rubikMedium(80)
                            .foregroundStyle(.white)
                            .opacity(0.65)
                    }
                    Text("Commander")
                        .avenir(30)
                        .foregroundStyle(.white)
                    
                }
            }
            .padding(30)

            //Custom Button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.35)) { showKeypad.toggle() }
            }) {
                VStack {
                    ZStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.accent)
                        Text("???")
                            .rubikMedium(60)
                            .foregroundStyle(.white)
                            .opacity(0.65)
                    }
                    Text("Custom")
                        .avenir(30)
                        .foregroundStyle(.white)
                    
                }

            }
            .padding(30)
        }
    }
}



#Preview {
    LifeSelection()
}
