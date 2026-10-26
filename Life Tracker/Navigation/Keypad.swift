//
//  Keypad.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/25/26.
//

import SwiftUI

var buttonHeight: CGFloat = 60
var buttonWidth: CGFloat = 60

struct Keypad: View {
    @State var numberString: String = "0"
    @Binding var showKeypad: Bool
    var body: some View {
        VStack {
            Text("\(numberString)")
                .rubik(min(buttonWidth, buttonHeight) / 1.5)
                .padding(.bottom, 03)
            HStack {
                NumberButton(numberString: $numberString, number: 1)
                NumberButton(numberString: $numberString, number: 2)
                NumberButton(numberString: $numberString, number: 3)

            }
            HStack {
                NumberButton(numberString: $numberString, number: 4)
                NumberButton(numberString: $numberString, number: 5)
                NumberButton(numberString: $numberString, number: 6)
            }
            
            HStack {
                NumberButton(numberString: $numberString, number: 7)
                NumberButton(numberString: $numberString, number: 8)
                NumberButton(numberString: $numberString, number: 9)
            }
            HStack {
                Button(action: {
                    deleteFromNumber()
                }) {
                    Image(systemName: "delete.left")
                        .font(.system(size: 25))
                        .foregroundStyle(.black)
                        .padding()
                        .frame(width: buttonWidth, height: buttonHeight)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                NumberButton(numberString: $numberString, number: 0)
                Button(action: {
                    GameSettings.shared.startingLife = Int(numberString)!
                    GameSettings.shared.commander = false
                    withAnimation(.easeInOut(duration: 0.35)) { showKeypad = false }
                    Path.shared.navPath.append(Route.playerCountSelection)
                }) {
                    Image(systemName: "return.left")
                        .font(.system(size: 25))
                        .foregroundStyle(.black)
                        .padding()
                        .frame(width: buttonWidth, height: buttonHeight)
                        .background(.accent)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(.thickMaterial)
        .cornerRadius(10)
    }
    
    func deleteFromNumber() {
        if numberString.count != 0 {
            numberString = String(numberString.dropLast())
        }
        if numberString.count == 0 {
            numberString = "0"
        }
    }
}

struct NumberButton: View {
    @Binding var numberString: String
    var number: Int
    var body: some View {
        Button(action: {
            addNumberToString()
        }) {
            Text("\(number)")
                .rubik(min(buttonWidth, buttonHeight) / 2.5)
                .foregroundStyle(.black)
                .padding()
                .frame(width: buttonWidth, height: buttonHeight)
                .background(Color.gray)
                .cornerRadius(10)
        }
    }
    
    func addNumberToString() {
        let lengthOfNumber = numberString.count
        let lengthLimit = 3
        if lengthOfNumber < lengthLimit {
            if numberString == "0" {
                numberString = number.description
            } else {
                numberString += number.description
            }
        }
    }
}

#Preview {
    Keypad(showKeypad: .constant(true))
}
