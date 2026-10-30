//
//  Layout Selection.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/29/26.
//

import SwiftUI
let layouts: [(Int, String)] = [
    (2, ""),
    (3, "Y"),
    (3, "Z"),
    (4, ""),
    (4, "Plus")
]

struct LayoutSelection: View {
    let gridLayout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var playerCount: Int { GameSettings.shared.playerCount }
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("Life Selection")
                    .heading()
                    .foregroundStyle(.white)
                    .padding()
                LazyVGrid(columns: gridLayout) {
                    ForEach(layouts.filter { $0.0 == playerCount }, id: \.1) { layout in
                        Layout_Selection_Previews(playerCount: layout.0, layout: layout.1)
                    }
                }
                .padding(40)
                Spacer()
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            CustomBackButton()
        }
    }
}

struct Layout_Selection_Previews: View {
    @Environment(\.modelContext) var context
    var playerCount: Int
    var layout: String
    let borderWidth: CGFloat = 5
    let previewSize = CGSize(width: UIScreen.main.bounds.width / 4.5, height: UIScreen.main.bounds.height / 5)
    let previewCornerSize: CGFloat = 20
    var body: some View {
        Button(action: {
            GameSettings.shared.layout = layout
            startGame()
            Path.shared.navPath.append(getRoute(playerCount: playerCount, layout: layout))
        }) {
            switch playerCount {
            case 2:
                twoPlayerPreview
            case 3:
                switch layout {
                case "Y":
                    threePlayerYPreview
                case "Z":
                    threePlayerZPreview
                default:
                    threePlayerYPreview
                }
            case 4:
                switch layout {
                case "":
                    fourPlayerPreview
                case "Plus":
                    fourPlayerPlusPreview
                default:
                    fourPlayerPreview
                }
            default:
                twoPlayerPreview
            }
        }
    }
    
    var twoPlayerPreview: some View {
        ZStack {
            Color.white
            VStack(spacing: borderWidth) {
                verticalPreview
                    .foregroundStyle(Color("Player2.1"))
                    .rotationEffect(.degrees(180))
                    
                verticalPreview
                    .foregroundStyle(Color("Player2.2"))
            }
            .clipShape(RoundedRectangle(cornerRadius: previewCornerSize-borderWidth))
            .frame(width: previewSize.width-2*borderWidth, height: previewSize.height-2*borderWidth)
        }
        .clipShape(RoundedRectangle(cornerRadius: previewCornerSize))
        .frame(width: previewSize.width, height: previewSize.height)

    }
    
    var threePlayerYPreview: some View {
        ZStack {
            Color.white
            VStack(spacing: borderWidth) {
                HStack(spacing: borderWidth) {
                    HorizontalPreview(cornerRadii: [0,5,5,5])
                        .foregroundStyle(Color("Player2.1"))

                    HorizontalPreview(cornerRadii: [5,0,5,5])
                        .rotationEffect(.degrees(180))
                        .foregroundStyle(Color("Player2.2"))


                    
                }
                verticalPreview
                    .foregroundStyle(Color("Player2.3"))
                    .frame(height: previewSize.height / 7 * 3)
                    
            }
            .clipShape(RoundedRectangle(cornerRadius: previewCornerSize-borderWidth))
            .frame(width: previewSize.width-2*borderWidth, height: previewSize.height-2*borderWidth)
        }
        .clipShape(RoundedRectangle(cornerRadius: previewCornerSize))
        .frame(width: previewSize.width, height: previewSize.height)

    }
    
    var threePlayerZPreview: some View {
        ZStack {
            Color.white
            VStack(spacing: borderWidth) {
                    HorizontalPreview(cornerRadii: [0,5,5,5])
                        .foregroundStyle(Color("Player2.1"))

                    HorizontalPreview(cornerRadii: [5,5,5,5])
                        .rotationEffect(.degrees(180))
                        .foregroundStyle(Color("Player2.2"))
                    HorizontalPreview(cornerRadii: [5,0,0,5])
                        .foregroundStyle(Color("Player2.3"))
                    
            }
            .clipShape(RoundedRectangle(cornerRadius: previewCornerSize-borderWidth))
            .frame(width: previewSize.width-2*borderWidth, height: previewSize.height-2*borderWidth)
        }
        .clipShape(RoundedRectangle(cornerRadius: previewCornerSize))
        .frame(width: previewSize.width, height: previewSize.height)

    }
    
    var fourPlayerPreview: some View {
        ZStack {
            Color.white
            VStack(spacing: borderWidth) {
                HStack(spacing: borderWidth) {
                    HorizontalPreview(cornerRadii: [0,5,5,5])
                        .foregroundStyle(Color("Player2.1"))
                    
                    HorizontalPreview(cornerRadii: [5,5,5,5])
                        .rotationEffect(.degrees(180))
                        .foregroundStyle(Color("Player2.2"))
                }
                HStack(spacing: borderWidth) {
                    HorizontalPreview(cornerRadii: [0,5,5,5])
                        .foregroundStyle(Color("Player2.3"))
                    
                    HorizontalPreview(cornerRadii: [5,5,5,5])
                        .rotationEffect(.degrees(180))
                        .foregroundStyle(Color("Player2.4"))
                }
                    
            }
            .clipShape(RoundedRectangle(cornerRadius: previewCornerSize-borderWidth))
            .frame(width: previewSize.width-2*borderWidth, height: previewSize.height-2*borderWidth)
        }
        .clipShape(RoundedRectangle(cornerRadius: previewCornerSize))
        .frame(width: previewSize.width, height: previewSize.height)

    }
    
    var fourPlayerPlusPreview: some View {
        ZStack {
            Color.white
            VStack(spacing: borderWidth) {
                verticalPreview
                    .foregroundStyle(Color("Player2.1"))
                    .rotationEffect(.degrees(180))
                    .frame(height: previewSize.height / 4)
                
                HStack(spacing: borderWidth) {
                    HorizontalPreview(cornerRadii: [0,5,5,5])
                        .foregroundStyle(Color("Player2.2"))

                    HorizontalPreview(cornerRadii: [5,0,5,5])
                        .rotationEffect(.degrees(180))
                        .foregroundStyle(Color("Player2.3"))


                    
                }
                verticalPreview
                    .foregroundStyle(Color("Player2.4"))
                    .frame(height: previewSize.height / 4)

                    
            }
            .clipShape(RoundedRectangle(cornerRadius: previewCornerSize-borderWidth))
            .frame(width: previewSize.width-2*borderWidth, height: previewSize.height-2*borderWidth)
        }
        .clipShape(RoundedRectangle(cornerRadius: previewCornerSize))
        .frame(width: previewSize.width, height: previewSize.height)

    }
    
    var verticalPreview: some View {
        UnevenRoundedRectangle(5, 0, 0, 5)
            .overlay(
                Image("playerIcon")
                    .renderingMode(.template)
                    .resize(to: 15)
                    .foregroundStyle(.white)
            )
    }
    
    func startGame() {
        let game = Game(
            playerCount: GameSettings.shared.playerCount,
            startingLife: GameSettings.shared.startingLife,
            commander: GameSettings.shared.commander,
            layout: GameSettings.shared.layout)
        GameSettings.shared.game = game
        context.insert(game)
        try? context.save()
    }
}

func getRoute(playerCount: Int, layout: String) -> Route {
    switch playerCount {
    case 2:
        return Route.twoPlayerView
    case 3:
        switch layout {
        case "Y":
            return Route.threePlayerYView
        case "Z":
            return Route.threePlayerZView
        default:
            return Route.twoPlayerView
        }
    case 4:
        switch layout {
        case "":
            return Route.fourPlayerView
        case "Plus":
            return Route.fourPlayerPlusView
        default:
            return Route.twoPlayerView
        }
    default:
        return Route.twoPlayerView
    }
}

struct HorizontalPreview: View {
    var cornerRadii: [CGFloat]

    var body: some View {
        UnevenRoundedRectangle(cornerRadii[0], cornerRadii[1], cornerRadii[2], cornerRadii[3])
            .overlay(
                Image("playerIcon")
                    .renderingMode(.template)
                    .resize(to: 15)
                    .foregroundStyle(.white)
                    .rotationEffect(.degrees(90))
            )
    }
}

#Preview {
    LayoutSelection()
}
