//
//  Text+Font.swift
//  Life Tracker
//
//  Created by Deven Mak on 10/13/26.
//

import Foundation
import SwiftUI

extension Text {
    func rubikMedium(_ size: CGFloat) -> some View {
        self
            .font(.custom("Rubik-Medium", size: size))
    }
}

extension Text {
    func rubik(_ size: CGFloat) -> some View {
        self
            .font(.custom("Rubik-Regular", size: size))
    }
}

extension Text {
    func avenirMedium(_ size: Int) -> some View {
        self
            .font(Font.custom("AvenirNextCondensed-Medium", size: CGFloat(size)))
    }
}

extension Text {
    func avenir(_ size: Int) -> some View {
        self
            .font(Font.custom("AvenirNextCondensed-Regular", size: CGFloat(size)))
    }
}

extension Text {
    func heading() -> some View {
        self
            .font(Font.custom("AvenirNextCondensed-Medium", size: 55))
    }
}
