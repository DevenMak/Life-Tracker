//
//  Extensions.swift
//  Life Tracker
//
//  Created by Deven Mak on 3/31/26.
//

import SwiftUI

extension Image {
    func iconStyle() -> some View {
        self
            .renderingMode(.template)
            .resizable()
            .frame(width: 30, height: 30)
        
    }
}

extension Text {
    func boldNumberStyle() -> some View {
        self
            .font(Font.custom("Rubik-Medium", size: 50))
    }
}

extension Text {
    func numberStyle(_ size: Int) -> some View {
        self
            .font(Font.custom("Rubik-Regular", size: CGFloat(size)))
    }
}

extension UnevenRoundedRectangle {
    init(_ tl: CGFloat, _ bl: CGFloat, _ bt: CGFloat, _ tt: CGFloat) {
        self.init(topLeadingRadius: tl, bottomLeadingRadius: bl, bottomTrailingRadius: bt, topTrailingRadius: tt)
    }
}

extension Text {
    func large() -> some View {
        self
            .font(Font.custom("AvenirNextCondensed-Regular", size: 30))
    }
} // large

extension Text {
    func heading() -> some View {
        self
            .font(Font.custom("AvenirNextCondensed-Medium", size: 50))
    }
} //header
extension Text {
    func body() -> some View {
        self
            .font(Font.custom("AvenirNextCondensed-Medium", size: 25))

    }
} //body

extension Text {
    func regular() -> some View {
        self
            .font(Font.custom("AvenirNextCondensed-Medium", size: 20))

    }
} //regular

extension TextField {
    func regular() -> some View {
        self
            .font(Font.custom("AvenirNextCondensed-Medium", size: 20))

    }
} //regular

extension Text {
    func small() -> some View {
        self
            .font(Font.custom("AvenirNextCondensed-Medium", size: 12))

    }
} //small

extension Text {
    func avenir(_ size: Int) -> some View {
        self
            .font(Font.custom("AvenirNextCondensed-Medium", size: CGFloat(size)))
    }
}

extension Color {
    init(_ r: Double, _ g: Double, _ b: Double) {
        self.init(red: r/255, green: g/255, blue: b/255)
    }
}
