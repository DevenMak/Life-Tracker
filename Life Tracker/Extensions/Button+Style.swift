//
//  Button+Style.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/13/26.
//

import Foundation
import SwiftUI

struct MenuButtonStyle: ButtonStyle {
    @Binding var isSelected: Bool
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(isSelected ? 1 : 0.9)
            .scaleEffect(configuration.isPressed && !isSelected ? 0.9 : 1)
            .animation(.bouncy, value: isSelected)
            .animation(.bouncy, value: configuration.isPressed)

    }
}

struct MenuButtonButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
            .animation(.bouncy, value: configuration.isPressed)

    }
}
