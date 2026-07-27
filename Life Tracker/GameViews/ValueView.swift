//
//  ValueView.swift
//  Life Tracker
//
//  Created by Deven Mak on 3/23/26.
//

import SwiftUI

struct ValueView: View {
    @StateObject var valueVM = ValueViewModel.shared
    let player: Player
    @State var value: Value
    var valueColor: Color {
        Color(value.red, value.green, value.blue)
    }
    var body: some View {
        ZStack {
            UnevenRoundedRectangle(10, 0, 0, 0)
                .fill(.white)
            VStack(spacing: 0) {
                Button(action: {
                    valueVM.increaseValue(value)
                }) {
                    UnevenRoundedRectangle(10,0,0,0)
                        .fill(valueColor)
                }
                Button(action: {
                    valueVM.decreaseValue(value)
                }) {
                    Rectangle()
                        .fill(valueColor)
                }
            }
            VStack(spacing: 0) {
                Spacer()
                Text("\(value.count)")
                    .boldNumberStyle()
                if let iconName = value.iconName {
                    valueVM.getIcon(iconName)
                }
                Spacer()
                
                Text("\(value.name ?? "")")
                    .small()
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding()
            }
            .foregroundStyle(contrastTextColor(valueColor))
        }
    }
}

