//
//  Menu.swift
//  Life Tracker
//
//  Created by Deven Mak on 3/6/26.
//

import SwiftUI

struct ValueType: Hashable, Equatable {
    let name: String
    var id = UUID()
    let count: Int
    let iconName: String
    let rgb: (Double, Double, Double)
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(name)
    }
    static func == (lhs: ValueType, rhs: ValueType) -> Bool {
            return lhs.name == rhs.name
    }
}

let defaultValues = [
    ValueType(name: "Poison", count: 0, iconName: "poisonIcon", rgb: (97, 222, 42)),
    ValueType(name: "Energy", count: 0, iconName: "energyIcon", rgb: (255, 222, 33)),
    ValueType(name: "Storm", count: 0, iconName: "stormIcon", rgb: (159,159,159))

]

func getRandomDirection(playerCount: Int, randomPlayer: Int) -> Double {
    switch playerCount {
    case 2:
        switch randomPlayer {
        case 1: return 180
        case 2: return 0
        default: return 0
        }
    case 3:
        switch randomPlayer {
        case 1: return 180
        case 2: return 45
        case 3: return -45
        default: return 0
        }
    case 4:
        switch randomPlayer {
        case 1: return 180-45
        case 2: return 180+45
        case 3: return 45
        case 4: return -45
        default: return 0
        }
    default: return 0
    }
}

struct Menu: View {
    @StateObject var valueVM = ValueViewModel.shared
    @State var showCustomForm = false
    @State var selectedValues: [ValueType] = []
    @State var showPicker = false
    @State var extraRotation: Double = 0
    @State var finishText: String = ""

    @Binding var showMenu: Bool
    
    var body: some View {
        let gridLayout = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        
        ZStack {
            VStack {
                Text("Menu")
                    .heading()
                    .padding()
                LazyVGrid(columns: gridLayout) {
                    ForEach(defaultValues, id: \.self) { value in
                        //DEFAULT BUTTONS
                        Button(action: {
                            valueVM.selectValue(name: value.name, count: value.count, iconName: value.iconName, rgb: value.rgb, custom: false)
                            DispatchQueue.main.async {
                                print(valueVM.values.map {$0.name})
                            }

                        }) {
                            VStack {
                                Text("\(value.name)")
                                    .large()
                                    .padding(.bottom, -2)
                                valueVM.getIcon(value.iconName)
                            }
                            
                        }
                        .foregroundStyle(valueVM.values.contains(where: { $0.name == value.name } ) ? .green : .white)
                        .scaleEffect(1.2)
                        .buttonStyle(ShrinkingButton())
                        .padding()
                        
                    }
                    .padding()
                    //CUSTOM BUTTON
                    Button(action: {
                        withAnimation {
                            showCustomForm = true
                        }
                    }) {
                        VStack {
                            Text("Custom")
                                .large()
                                .padding(.bottom, -2)
                            Image(systemName: "questionmark.circle")
                                .iconStyle()
                        }
                        
                    }
                    .scaleEffect(1.2)
                    
                    .buttonStyle(ShrinkingButton())
                    //PICKER BUTTON
                    Button(action: {
                        
                        let playerCount = PlayerViewModel.shared.players.count
                        let randomPlayer = Int.random(in: 1...playerCount)
                        
                        extraRotation = getRandomDirection(playerCount: playerCount, randomPlayer: randomPlayer)
                        
                        finishText = "Player \(randomPlayer)"
                        print(playerCount)
                        withAnimation {
                            showPicker = true
                        }
                        
                    }) {
                        VStack(spacing: 0) {
                            Text("Picker")
                                .large()
                            Image("arrow.down.to.line.compact")
                                .iconStyle()
                            
                        }
                    }
                    .scaleEffect(1.2)
                    .buttonStyle(ShrinkingButton())
                    
                    
                }
                .padding()
                Spacer()
                //CLOSE BUTTON
                Button(action: {
                    withAnimation {
                        showMenu = false
                    }
                }) {
                    ButtonText(text: "Close")
                }
                .overlay(
                    ButtonBorder(text: "Close")
                )
                //MAIN MENU BUTTON
                Button(action: {
                    Path.shared.navPath = NavigationPath()
                }) {
                    ButtonText(text: "Main Menu")
                }
                .overlay(
                    ButtonBorder(text: "Main Menu")
                )
                
                Spacer()
            }
            
            if showPicker {
                Picker(extraRotation: extraRotation, finishText: finishText, isShowing: $showPicker, menuShowing: $showMenu)
                    
            }
            
            if showCustomForm {
                CustomForm(showCustomForm: $showCustomForm) 
            }
        }
        .padding(.top)
        .foregroundStyle(.white)

    }
}

struct ButtonText: View {
    var text: String
    var body: some View {
        Text("\(text)")
            .body()
            .foregroundStyle(.white)
            .padding()
            .frame(maxHeight: 65)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.white.opacity(0.4))
                    .stroke(.white, lineWidth: 2)
            )
            .padding()
    }
}

struct ButtonBorder: View {
    var text: String
    var body: some View {
        Text("\(text)")
            .foregroundStyle(.clear)
            .body()
            .padding()
            .frame(maxHeight: 65)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.white.opacity(0))
                    .stroke(.white, lineWidth: 2)
            )
            .allowsHitTesting(false)
    }
    
}


#Preview {
    Menu(showMenu: .constant(true))
}
