//
//  ValueView.swift
//  Life Tracker
//
//  Created by Deven Mak on 3/23/26.
//

import SwiftUI

struct ValueView: View {
    
    let player: Player
    let value: Value
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Button(action: {
                    ValueViewModel.shared.increaseValue(value)
                }) {
                    UnevenRoundedRectangle(10,0,0,0)
                        .fill(Color(value.red, value.green, value.blue))
                }
                Button(action: {
                    ValueViewModel.shared.decreaseValue(value)
                }) {
                    Rectangle()
                        .fill(Color(value.red, value.green, value.blue))
                }
            }
            VStack(spacing: 0) {
                Spacer()
                Text("\(value.count)")
                    .numberStyle()
                if let iconName = value.iconName {
                    ValueViewModel.shared.getIcon(iconName)
                }
                Spacer()
                
                Text("\(value.name ?? "")")
                    .small()
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding()
            }
            .foregroundStyle(.white)
        }
    }
}

