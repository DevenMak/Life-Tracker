//
//  FourPlayerGame.swift
//  Life Tracker
//
//  Created by Deven Mak on 8/2/26.
//

import SwiftUI


extension UIApplication {
    static var currentSafeAreaInsets: UIEdgeInsets {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        return windowScene?.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero
    }
}

struct FourPlayerGame: View {
    @StateObject var playerVM: PlayerViewModel = .shared
    let playerWidth: CGFloat = (UIScreen.main.bounds.width-spacingBetweenPlayerViews)/2
    let playerHeight: CGFloat = (UIScreen.main.bounds.height-spacingBetweenPlayerViews)/2
    
    @State var menuOpen: Bool = false
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(edges: .all)
            VStack(spacing: spacingBetweenPlayerViews) {
                HStack(spacing: spacingBetweenPlayerViews) {
                    PlayerView(player: playerVM.players[0])
                        .frame(width: playerHeight, height: playerWidth)
                        .drawingGroup()
                        .rotationEffect(.degrees(90))
                        .frame(width: playerWidth, height: playerHeight)
                        .ignoresSafeArea()
                    PlayerView(player: playerVM.players[1])
                        .frame(width: playerHeight, height: playerWidth)
                        .drawingGroup()
                        .rotationEffect(.degrees(-90))
                        .frame(width: playerWidth, height: playerHeight)
                        .ignoresSafeArea()
                    
                    
                }
                HStack(spacing: spacingBetweenPlayerViews) {
                    PlayerView(player: playerVM.players[2])
                        .frame(width: playerHeight, height: playerWidth)
                        .drawingGroup()
                        .rotationEffect(.degrees(90))
                        .frame(width: playerWidth, height: playerHeight)
                        .ignoresSafeArea()
                    PlayerView(player: playerVM.players[3])
                        .frame(width: playerHeight, height: playerWidth)
                        .drawingGroup()
                        .rotationEffect(.degrees(-90))
                        .frame(width: playerWidth, height: playerHeight)
                        .ignoresSafeArea()
                    
                    
                }
                
            }
            .ignoresSafeArea()
            .blur(radius: menuOpen ? 5 : 0)
            
            Button(action: {
                withAnimation {
                    menuOpen = true
                }
            }) {
                Circle()
                    .fill(Color.white)
                    .stroke(.black, lineWidth: spacingBetweenPlayerViews)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "circle.grid.3x3.fill")
                            .renderingMode(.template)
                            .foregroundStyle(.black)
                    )
                    .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2)
            }
            .blur(radius: menuOpen ? 5 : 0)
            .buttonStyle(.expanding)
            .ignoresSafeArea(edges: .all)

            Color.black.ignoresSafeArea(edges: .all)
                .opacity(menuOpen ? 0.85 : 0)
            

            Menu(showMenu: $menuOpen)
                .opacity(menuOpen ? 1 : 0)
        }
        .navigationBarBackButtonHidden(true)

    }
}

struct TestPlayerView: View {
    var color: Color
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                
            }) {
                Rectangle()
                    .fill(color)
            }
            Button(action: {
                
            }) {
                Rectangle()
                    .fill(color)
            }
        }
        .compositingGroup()
        .overlay(PlayerText())
       
    }
}

struct PlayerText: View {
    var body: some View {
        VStack {
            Text("+")
            Spacer()
            VStack(spacing: 0) {
                Text("0")
                    .boldNumberStyle()
                
                Image("heartIcon")
                    .iconStyle()
            }
            Spacer()
            Text("-")
            
        }
            .padding()
    }
}

#Preview {
    FourPlayerGame()
}
