//
//  Menu.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/13/26.
//

import SwiftUI
import SwiftData


struct Menu: View {
    @Environment(\.modelContext) private var context
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
            Color.black.opacity(0.85).ignoresSafeArea()
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
                            .avenir(25)
                            
                        Image("arrow.down.to.line.compact")
                            .iconSize(30)
                    }
                    .padding(.horizontal, 25)
                    .frame(maxHeight: 60)
                    .background(.white.opacity(0.3))
                    .clipShape(Capsule())
                }
                .overlay(
                    HStack {
                        Text("Picker")
                            .avenir(25)
                            
                        Image("arrow.down.to.line.compact")
                            .iconSize(30)
                    }
                    .padding(.horizontal, 25)
                    .frame(maxHeight: 60)
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
                            .avenir(25)
                            .padding(.horizontal, 25)
                            .frame(maxHeight: 60)
                            .background(.white.opacity(0.3))
                            .clipShape(Capsule())
                    }
                    .overlay(
                        Text("Main Menu")
                            .avenir(25)
                            .padding(.horizontal, 25)
                            .frame(maxHeight: 60)
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
                        menuState.setShowMenu(false)
                    }) {
                        Text("Close")
                            .avenir(25)
                            .padding(.horizontal, 25)
                            .frame(maxHeight: 60)
                            .background(.white.opacity(0.3))
                            .clipShape(Capsule())
                    }
                    .overlay(
                        Text("Close")
                            .avenir(25)
                            .padding(.horizontal, 25)
                            .frame(maxHeight: 60)
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
            
            
            Color.black.opacity(showPicker ? 1 : 0).ignoresSafeArea()

            Picker()
                .opacity(showPicker ? 1 : 0)
                .rotationEffect(.degrees(rotationAmount))

        }
        .allowsHitTesting(menuState.showMenu ? true : false)
    }
    
    func pick() -> CGFloat {
        let playerCount = game.players.count
        let rotationAngle: CGFloat = CGFloat(Int.random(in: 2...3) * 360)
        let extraRotation = CGFloat(Int.random(in: 0...playerCount) * 360 / playerCount ) + (playerCount == 4 ? 45 : 0)
        return rotationAngle+extraRotation
    }
    
    func animateRotation() {
        let rotationAngle = pick()
        withAnimation(.easeOut(duration: rotationAngle * 0.002)) {
            rotationAmount = rotationAngle
        } completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                showPicker = false
                rotationAmount = 0
                menuState.setShowMenu(false)
            }
        }
    }
    
}

struct DefaultTallyButton: View {
    @Environment(\.modelContext) private var context
    var game: Game
    var name: String
    var gameTallies: [Tally] {
        var array: [Tally] = []
        game.players.forEach { $0.tallies.forEach { array.append($0) }}
        return array
    }
    var tallies: [Tally] { gameTallies.filter { $0.name == name } }
    var bindingTallySelected: Binding<Bool> {
        Binding(
            get: { tallies[0].order != 0},
            set: { newValue in}
        )
    }
    var tallySelected: Bool { tallies[0].order != 0 }
    
    var body: some View {
        Button(action: {
            withAnimation {
                selectTally()
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
    
    func selectTally() {
        let firstSlotOpen = !gameTallies.contains(where: { $0.order == 1}) && !game.commander
        let secondSlotOpen = !gameTallies.contains(where: { $0.order == 2})
        let tallyBeingSelected = tallies[0]
        if tallyBeingSelected.order == 0 { // If Tally not already showing
            if firstSlotOpen {
                tallies.forEach { tally in tally.order = 1 } // Put tally in slot 1
            } else if secondSlotOpen {
                tallies.forEach { tally in tally.order = 2 }// Put tally in slot 2
            } else {
                if TallyTracker.shared.orderToBeRemoved == 1 && !game.commander {
                    gameTallies.filter { $0.order == 1}.forEach { t in t.order = 0}
                    TallyTracker.shared.orderToBeRemoved = 2
                    tallies.forEach { tally in tally.order = 1 } // Put tally in slot 1
                } else {
                    gameTallies.filter { $0.order == 2}.forEach { t in t.order = 0}
                    TallyTracker.shared.orderToBeRemoved = 1
                    tallies.forEach { tally in tally.order = 2 }// Put tally in slot 2
                }
            }
        } else { // tally already showing
            tallies.forEach { tally in tally.order = 0 }// Take tally out
        }
        try? context.save()
    }
}

struct Picker: View {
    var body: some View {
        Image(systemName: "arrow.down")
            .iconSize(60)
            .foregroundStyle(.white)
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

