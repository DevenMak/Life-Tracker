//
//  Menu.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/13/26.
//

import SwiftUI
import SwiftData

class MenuState: ObservableObject {
    public static var shared = MenuState()
    @Published var showMenu: Bool = false
    
    func setShowMenu(_ showMenu: Bool) {
        withAnimation(.linear(duration: 5)) {
            self.showMenu = showMenu
        }
    }
}

struct Picker: View {
    var body: some View {
        Image(systemName: "arrow.down")
            .iconSize(60)
            .foregroundStyle(.white)
    }
}

struct Menu: View {
    var game: Game
    @State var showPicker: Bool = false
    @State var rotationAmount: CGFloat = 0
    @StateObject private var menuState = MenuState.shared
    var body: some View {
        let gridLayout = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
                
        ZStack {
            Color.black.ignoresSafeArea()
            VStack {
                Text("Menu")
                    .heading()
                    .padding()
                LazyVGrid(columns: gridLayout) {
                    DefaultTallyButton(game: game, name: "poison")
                    DefaultTallyButton(game: game, name: "storm")
                    DefaultTallyButton(game: game, name: "energy")
                    DefaultTallyButton(game: game, name: "custom")


                }
                .padding()
                //Picker Button
                Button(action: {
                    withAnimation {
                        showPicker = true
                    }
                    animateRotation()
                }) {
                    HStack {
                        Text("Picker")
                            .avenir(30)
                            
                        Image("arrow.down.to.line.compact")
                            .iconSize(30)
                    }
                    .padding(.horizontal, 30)
                    .frame(maxHeight: 65)
                    .background(.white.opacity(0.3))
                    .clipShape(Capsule())
                }
                .overlay(
                    HStack {
                        Text("Picker")
                            .avenir(30)
                            
                        Image("arrow.down.to.line.compact")
                            .iconSize(30)
                    }
                    .padding(.horizontal, 30)
                    .frame(maxHeight: 65)
                    .background(
                        Capsule()
                            .fill(.clear)
                            .strokeBorder(.white.secondary, lineWidth: 3)
                        )
                    .allowsHitTesting(false)

                )
                .foregroundStyle(.secondary)
                
                //Menu and Close Buttons
                HStack {
                    //Menu
                    Button(action: {
                        Path.shared.navPath = NavigationPath()
                        menuState.setShowMenu(false)
                    }) {
                        Text("Main Menu")
                            .avenir(30)
                            .padding(.horizontal, 30)
                            .frame(maxHeight: 65)
                            .background(.white.opacity(0.3))
                            .clipShape(Capsule())
                    }
                    .overlay(
                        Text("Main Menu")
                            .avenir(30)
                            .padding(.horizontal, 30)
                            .frame(maxHeight: 65)
                            .background(
                                Capsule()
                                    .fill(.clear)
                                    .strokeBorder(.white.secondary, lineWidth: 3)
                            )
                            .allowsHitTesting(false)
                    )
                    .padding()
                    //Close
                    Button(action: {
                        withAnimation {
                            menuState.showMenu = false
                        }
                    }) {
                        Text("Close")
                            .avenir(30)
                            .padding(.horizontal, 30)
                            .frame(maxHeight: 65)
                            .background(.white.opacity(0.3))
                            .clipShape(Capsule())
                    }
                    .overlay(
                        Text("Close")
                            .avenir(30)
                            .padding(.horizontal, 30)
                            .frame(maxHeight: 65)
                            .background(
                                Capsule()
                                    .fill(.clear)
                                    .strokeBorder(.white.secondary, lineWidth: 3)
                            )
                            .allowsHitTesting(false)
                    )
                    
                }
                .foregroundStyle(.secondary)
            }
            .foregroundStyle(.white)
            .blur(radius: showPicker ? 5 : 0)

            
            
            Color.black.opacity(showPicker ? 1 : 0)

            Picker()
                .opacity(showPicker ? 1 : 0)
                .rotationEffect(.degrees(rotationAmount))

        }
    }
    
    func pick() -> CGFloat {
        let playerCount = game.players.count
        let rotationAngle: CGFloat = CGFloat(Int.random(in: 2...3) * 360)
        let extraRotation = CGFloat(Int.random(in: 0...playerCount) * 360 / playerCount )
        return rotationAngle+extraRotation
    }
    
    func animateRotation() {
        let rotationAngle = pick()
        withAnimation(.easeOut(duration: rotationAngle * 0.002)) {
            rotationAmount = rotationAngle
        } completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation {
                    showPicker = false
                } completion: {
                    rotationAmount = 0
                    menuState.setShowMenu(false)
                }
            }
        }
    }
    
}

struct DefaultTallyButton: View {
    @Environment(\.modelContext) private var context
    
    var game: Game
    var name: String
    
    @Query private var allTallies: [Tally]
    
    var tallies: [Tally] {
        allTallies.filter { t in
            t.name == name
        }
    }
    
    var bindingTallySelected: Binding<Bool> {
        Binding(
            get: {
                if tallies.isEmpty { return false }
                return tallies[0].order != 0
            }, set: { newValue in}
        )

    }
    
    var tallySelected: Bool {
        if tallies.isEmpty { return false }
        return tallies[0].order != 0
    }
    
    var body: some View {
        Button(action: {
            for tally in tallies {
                if tally.order == 0 {
                    tally.order = 1
                } else {
                    tally.order = 0
                }
            }
        }) {
            ZStack {
                Image("\(name)Icon")
                    .iconSize(name == "poison" ? 80 : 60)
                    .foregroundStyle(tallySelected ? AnyShapeStyle(.accent.secondary) : AnyShapeStyle(.accent.tertiary))
                Text(name.capitalized)
                    .avenirMedium(40)
                    .foregroundStyle(tallySelected ? .primary : .secondary)
            }
        }
        .padding()
        .buttonStyle(MenuButtonStyle(isSelected: bindingTallySelected))
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Game.self, configurations: config)

    let game = Game(playerCount: 2, startingLife: 40 )
    container.mainContext.insert(game)

    return Menu(game: game)
        .modelContainer(container)
}

