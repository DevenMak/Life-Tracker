//
//  MenuButton.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/13/26.
//

import SwiftUI

struct MenuButton: View {
    @StateObject private var menuState = MenuState.shared
    var body: some View {
        Button(action: {
            menuState.setShowMenu(true)
        }) {
            ZStack {
                Circle()
                    .fill(.white)
                    .strokeBorder(.black, lineWidth: 7)
                    .frame(width: 55, height: 55)
                Image(systemName: "circle.grid.3x3.fill")
                    .font(.system(size: 25))
                    .foregroundStyle(.black)
            }
        }
        .buttonStyle(MenuButtonButtonStyle())
    }
}

#Preview {
    MenuButton()
}
